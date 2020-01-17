function route()
    local config = require 'sumei-config'
    for k,v in pairs(config.veiwNumModuleUris) do
        local match = string.match(ngx.var.uri, v.uri)
        if match then 
            local model = v.model
            local action = require(v.action)
            local res, msg = pcall(action.run, model, match)
        end
    end
end

local res, msg = pcall(route)

if not res then
    ngx.log(ngx.ERR, 'route error', msg)
end