module = {}
function module.run(model, id)
    local json = require 'json'
    local redis = require 'redis'
    local mysql = require 'mysql'
    local cookie = require 'cookie'
    local request = require 'request'
    local config = require 'sumei-config'

    local headers = ngx.req.get_headers()
    local ip = headers["X-REAL-IP"] or headers["X_FORWARDED_FOR"] or ngx.var.remote_addr or "0.0.0.0"

    --链接redis
    local red = redis:new()
    red:set_timeout(1000) -- 1 second
    local ok, err = red:connect(config.redis['redisHost'], config.redis['redisPort'])
    if not ok then 
        ngx.log(ngx.ERR, 'connect redis failed', err)
    end

    --增加浏览量
    local dailyViewNumKey = string.format(config.dailyViewNumKeyMap[model], os.date('%Y%m%d'), id)
    local dailyViewNum, err = red:incr(dailyViewNumKey)
    if not dailyViewNum then
        ngx.log(ngx.ERR, 'redis incr failed', err)
    end

    --增加uv量
    local dailyUserViewNumSetKey = string.format(config.dailyUserViewNumKeyMap[model], os.date('%Y%m%d'), id)
    local dailyIpViewNumSetKey = string.format(config.dailyIpViewNumKeyMap[model], os.date('%Y%m%d'), id)
    local dailyIpViewNum, err = red:sadd(dailyIpViewNumSetKey, ip)
    if not dailyIpViewNum then
        ngx.log(ngx.ERR, 'redis sadd failed', err)
    end

    --cookie获取uuid
    local cookie = cookie:new()
    local allCookie = cookie:get_all()
    if allCookie.sm_uuid ~= nil and allCookie.sm_uuid ~= ngx.null then
        local smuuid = allCookie.sm_uuid
        local dailyUserViewNum, err = red:sadd(dailyUserViewNumSetKey, smuuid)
    end
    if not dailyUserViewNum then
        ngx.log(ngx.ERR, 'redis sadd failed', err)
    end
end

return module