config = {}

config.mysql = {
    host = "127.0.0.1",
    port = 3306,
    database = "sumei",
    user = "homestead",
    password = "secret",
    charset = "utf8",
    max_packet_size = 1024 * 1024,
}

config.moduleDBMap = {
    activity = 'activities',
    special = 'specials',
    story = 'stories',
    template = 'site_templates'
}

config.redis = {
    redisHost = '127.0.0.1',
    redisPort = '6379'
}

config.viewNumKeyMap = {
    activity = 'sumei_database_view_num:pv:activities:%d',
    special = 'sumei_database_view_num:pv:specials:%d',
    story = 'sumei_database_view_num:pv:stories:%d',
    template = 'sumei_database_view_num:pv:site_templates:%d'
}

config.dailyViewNumKeyMap = {
    activity = 'sumei_database_view_num:daily:%s:pv:activities:%d',
    special = 'sumei_database_view_num:daily:%s:pv:specials:%d',
    story = 'sumei_database_view_num:daily:%s:pv:stories:%d',
    template = 'sumei_database_view_num:daily:%s:pv:site_templates:%d'
}

config.userViewNumKeyMap = {
    activity = 'sumei_database_view_num:old:uv:activities:%d',
    special = 'sumei_database_view_num:old:uv:specials:%d',
    story = 'sumei_database_view_num:old:uv:stories:%d',
    template = 'sumei_database_view_num:old:uv:site_templates:%d'
}

config.dailyUserViewNumKeyMap = {
    activity = 'sumei_database_view_num:daily:%s:uv:activities:%d',
    special = 'sumei_database_view_num:daily:%s:uv:specials:%d',
    story = 'sumei_database_view_num:daily:%s:uv:stories:%d',
    template = 'sumei_database_view_num:daily:%s:uv:site_templates:%d'
}

config.ipViewNumKeyMap = {
    activity = 'sumei_database_view_num:old:ip:activities:%d',
    special = 'sumei_database_view_num:old:ip:specials:%d',
    story = 'sumei_database_view_num:old:ip:stories:%d',
    template = 'sumei_database_view_num:old:ip:site_templates:%d'
}

config.dailyIpViewNumKeyMap = {
    activity = 'sumei_database_view_num:daily:%s:ip:activities:%d',
    special = 'sumei_database_view_num:daily:%s:ip:specials:%d',
    story = 'sumei_database_view_num:daily:%s:ip:stories:%d',
    template = 'sumei_database_view_num:daily:%s:ip:site_templates:%d'
}

config.veiwNumModuleUris = {
    {
        uri = '/courses/(%d+)/online',
        action = 'set-counter',
        model = 'story',
    },
    {
        uri = '/courses/online/(%d+)',
        action = 'set-counter',
        model = 'story',
    },
    {
        uri = '/special/(%d+)',
        action = 'set-counter',
        model = 'special',
    },
}

return config