hosted_init()

--if CONFIG.auto_resolution then
    gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)
--else
    --gl.setup(CONFIG.width, CONFIG.height)
--end

--util.no_globals()
local on = false
local font = resource.load_font "silkscreen.ttf"
util.data_mapper{
    state = function(state)
        on = state == '1'
    end,
}


node.set_flag("slow_gc", false)

local iblib = require "iblib"

setmetatable(_G, {
    __newindex = function(t, k, v)
        error("cannot assign " .. k)
    end
})



local title_start = 99999999

local idx = 0 -- offset before first item. will be incremented during first get_next_item
local playlist_source = function()
    return CONFIG.playlist
end;
local playlist_source2 = function()
    return CONFIG.playlist2
end;

local overlay = resource.create_colored_texture(0, 0, 0, 1)

local player = iblib.playlist{
    get_next_item = function()
        local playlist = playlist_source()
        idx = idx + 1
        if idx > #playlist then
            idx = 1
        end

        local item = playlist[idx]
        if not item then
            return nil
        else
            return {
                title = item.title;
                duration = item.duration;
                obj = item.file();
            }
        end
    end;

     get_switch_time = function()
        return 0
    end;

    fade = function(...)
        title_start = sys.now() + 1.0
        return 0
    end;
   

    draw = util.draw_correct;
}


local player2 = iblib.playlist{
    get_next_item = function()
        local playlist = playlist_source2()
        idx = idx + 1
        if idx > #playlist then
            idx = 1
        end
        
        local item = playlist[idx]
        if not item then
            return nil
        else
            return {
                title = item.title;
                duration = item.duration;
                obj = item.file();
            }
        end
    end;
    get_switch_time = function()
        return 0
    end;

    fade = function(...)
        title_start = sys.now() + 1.0
        return 0
    end;

    draw = util.draw_correct;
}

function node.render()
    --CONFIG.background_color.clear()

    if on then
    player2.draw(0, 0, WIDTH, HEIGHT) --font:write(120, 320, "RED", 100, 1,1,1,1)        
    else
    player.draw(0, 0, WIDTH, HEIGHT) 
    end   
   

end
