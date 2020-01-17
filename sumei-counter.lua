local json = require 'json'
local redis = require 'redis'
local mysql = require 'mysql'
local cookie = require 'cookie'
local request = require 'request'
local config = require 'sumei-config'
--获取post 参数json格式
local args = request.getArgs()
local module = args['module']
local id = args['id']

--链接redis
local red = redis:new()
red:set_timeout(1000) -- 1 second
local ok, err = red:connect(config.redis['redisHost'], config.redis['redisPort'])
if not ok then 
    ngx.log(ngx.ERR, 'connect redis failed')
    return
end
local viewNumKey = string.format(config.viewNumKeyMap[module], id)
local viewNum = red:get(viewNumKey)
--如果对应字段不存在则取数据库字段并存入redis
if ngx.null == viewNum or ngx.null == oldUserViewNum then
    local db, err = mysql:new()
    if not db then
        ngx.log(ngx.ERR, "failed to instantiate mysql: ", err)
    end

    db:set_timeout(1000) -- 1 sec

    local ok, err, errcode, sqlstate = db:connect{
        host = config.mysql['host'],
        port = config.mysql['port'],
        database = config.mysql['database'],
        user = config.mysql['user'],
        password = config.mysql['password'],
        charset = config.mysql['charset'],
        max_packet_size = config.mysql['max_packet_size'],
    }

    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err, ": ", errcode, " ", sqlstate)
    end
    local res, err, errcode, sqlstate =
        db:query("select view_num, user_view_num from " .. config.moduleDBMap[module] .. ' where id=' .. id, 10)
    if not res then
        ngx.log(ngx.ERR, "bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    end

    if ngx.null == viewNum then
        red:set(viewNumKey, res[1]['view_num'])
        viewNum = res[1]['view_num']
        red:expire(viewNumKey, 90000)
    end
end
local dailyViewNumKey = string.format(config.dailyViewNumKeyMap[module], os.date('%Y%m%d'), id)
dailyViewNum, err = red:get(dailyViewNumKey)
if dailyViewNum == ngx.null or dailyViewNum == nil then
    dailyViewNum = 0
end

local responseData = {
    count = tonumber(viewNum) + tonumber(dailyViewNum)
}
ngx.header['Content-Type'] = 'application/json; charset=utf-8'
ngx.print(json.encode(responseData))