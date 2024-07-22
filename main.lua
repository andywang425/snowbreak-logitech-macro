-- 用户配置
Config = {
    -- 全局开关
    enable = true,
    -- 游戏内灵敏度（填入你在游戏里设置的值）
    sensitivity = {
        -- 不开镜
        noAim = 50
    },
    -- 使用锁定键来控制宏的开启和关闭（仅在锁定键开启时启用宏）
    lockKeySwitch = {
        -- 是否开启
        enable = true,
        -- 使用的锁定键，可以为 scrolllock，capslock 或 numlock
        key = "capslock"
    },
    -- 延时设置
    sleep = {
        -- 进行一次鼠标操作后的延时（单位：毫秒；请根据设备性能调整）
        mouse = 2,
        -- 进行一次键盘操作后的延时（单位：毫秒；请根据设备性能调整）
        -- 技能键按下去之后游戏需要一些时间来响应，因此这个值不宜过小
        keyboard = 100,
        -- 随机延时设置
        random = {
            -- 是否开启
            enable = true,
            -- 延时上下浮动的比率（范围：[0, 1]）
            -- 若延时为100毫秒，比率设置为0.1，则延时在90~110毫秒内的浮动
            extent = 0.01
        }
    },
    -- 鼠标移动设置
    mouseMove = {
        -- 随机移动设置
        random = {
            -- 是否启动
            enable = true,
            -- 鼠标移动时发生偏差的幅度
            extent = {
                -- X轴上的偏差幅度（范围：[0, 1]）
                -- 若鼠标在X轴上的移动距离为1000，偏差幅度设置为0.01，则在移动距离在990~1010内浮动
                xAxis = 0.01,
                -- Y轴上的偏差幅度（范围：[0, 1]）
                -- 若鼠标在Y轴上的移动距离为500，偏差幅度设置为0.01，则在移动距离在495~505内浮动
                yAxis = 0.01
            }
        }
    },
    -- 里芙-无限之视 E技能转圈宏设置
    lyfe = {
        -- 是否开启
        enable = true,
        -- 触发宏的G key的数字部分
        triggerGKey = 5,
        -- 将转圈的动作拆分为多少个步骤（请根据设备性能调整）
        -- 步骤数量越多转得越流畅、越慢，反之则转得越不自然、越快
        -- 若开启的转两圈功能，则每圈使用一半的步骤数量
        steps = 50,
        -- 转圈的过程中Y轴上的移动距离（模拟一个垂直方向上的移动误差）
        -- 若填10，则每次移动视角时会在[-10, 10]范围内产生一个随机的Y轴上的偏移
        yAxisErrorDistance = 5,
        -- 转两圈设置（转一圈后向上或向下移动视角再转一圈，可能可以覆盖到更多敌人）
        doubleSpin = {
            -- 是否开启
            enable = true,
            -- 两圈衔接过程中上下拉动视角时X轴方向上的移动距离（模拟一个水平方向上的移动误差）
            -- 若填10，则会在[-10, 10]范围内产生一个随机的X轴上的偏移
            xAxisErrorDistance = 5,
            -- 两圈衔接过程中向上或向下移动视角的幅度（范围：[0, 1]）
            -- 若为正数则向下移动视角，反之则向上移动视角
            -- 取值为1时表示从最高视角拉到最低视角的幅度，取值为0时不移动视角
            yAxisMoveExtent = -0.2
        },
        -- 转圈完成后自动释放爆发技（Q技能）
        autoUltimate = true
    }
}
-- 用户配置结束，以下代码若不清楚原理请勿修改

-- 全局常量
-- 当游戏内不开镜灵敏度为 1 时，视角横着转一圈鼠标所需要在X轴上移动的距离
Xdistance = 123450
-- 当游戏内不开镜灵敏度为 1 时，视角竖着从上拉到下鼠标所需要在Y轴上移动的距离
Ydistance = 48000

-- 宏数据，根据用户配置计算得到
Data = {
    -- 延时数据
    sleep = {
        -- 鼠标
        mouse = {
            min = 0,
            max = 0
        },
        -- 键盘
        keyboard = {
            min = 0,
            max = 0
        }
    },
    -- 里芙-无限之视
    lyfe = {
        -- 每次转圈的步骤数量
        stepsEachSpin = 0,
        -- 每一步鼠标的移动距离
        stepDistance = {
            xAxis = {
                min = 0,
                max = 0
            },
            yAxis = {
                min = 0,
                max = 0
            }
        },
        -- 转两圈衔接过程中的鼠标移动距离
        doubleSpinTransitionDistance = {
            xAxis = {
                min = 0,
                max = 0
            },
            yAxis = {
                min = 0,
                max = 0
            }
        }
    }
}

-- 工具表
Utils = {
    -- 计算最小值时使用的比率
    getMinRate = function(base, extent)
        if base >= 0 then
            return 1 - extent
        else
            return 1 + extent
        end
    end,
    -- 计算最大值时使用的比率
    getMaxRate = function(base, extent)
        if base >= 0 then
            return 1 + extent
        else
            return 1 - extent
        end
    end,
    -- 随机值的下限（向下取整）
    randomMin = function(base, extent)
        return math.floor(base * Utils.getMinRate(base, extent))
    end,
    -- 随机值的上限（向上取整）
    randomMax = function(base, extent)
        return math.ceil(base * Utils.getMaxRate(base, extent))
    end,
    -- 计算误差范围
    randomErrorRange = function(base, extent)
        return {
            min = Utils.randomMin(base, extent),
            max = Utils.randomMin(base, extent)
        }
    end,
    -- 计算格式为[-n, n]的误差范围
    randomNegativeToPositiveRange = function(base, extent)
        return {
            min = Utils.randomMin(-base, extent),
            max = Utils.randomMin(base, extent)
        }
    end
}

-- 初始化
-- 随机延时
if Config.sleep.random.enable then
    Data.sleep.mouse = Utils.randomErrorRange(Config.sleep.mouse, Config.sleep.random.extent)
    Data.sleep.keyboard = Utils.randomErrorRange(Config.sleep.keyboard, Config.sleep.random.extent)
else
    Data.sleep.mouse.min = Config.sleep.mouse
    Data.sleep.mouse.max = Config.sleep.mouse
    Data.sleep.keyboard.min = Config.sleep.keyboard
    Data.sleep.keyboard.max = Config.sleep.keyboard
end
-- 里芙-无限之视 E技能转圈宏
if Config.lyfe.enable then
    -- 转两圈
    if Config.lyfe.doubleSpin.enable then
        -- 每圈使用一半的步骤数量
        Data.lyfe.stepsEachSpin = math.floor(Config.lyfe.steps / 2)
        -- 转两圈衔接过程中，鼠标在Y轴的基础移动距离
        local baseYAxisMoveDistance = Ydistance / Config.sensitivity.noAim * Config.lyfe.doubleSpin.yAxisMoveExtent
        -- 鼠标随机移动
        if Config.mouseMove.random.enable then
            Data.lyfe.doubleSpinTransitionDistance.xAxis = Utils.randomNegativeToPositiveRange(
                Config.lyfe.doubleSpin.xAxisErrorDistance, Config.mouseMove.random.extent.xAxis)
            Data.lyfe.doubleSpinTransitionDistance.yAxis = Utils.randomErrorRange(baseYAxisMoveDistance,
                Config.mouseMove.random.extent.yAxis)
        else
            Data.lyfe.doubleSpinTransitionDistance.xAxis.min = Config.lyfe.doubleSpin.xAxisErrorDistance
            Data.lyfe.doubleSpinTransitionDistance.xAxis.max = Config.lyfe.doubleSpin.xAxisErrorDistance
            Data.lyfe.doubleSpinTransitionDistance.yAxis.min = baseYAxisMoveDistance
            Data.lyfe.doubleSpinTransitionDistance.yAxis.max = baseYAxisMoveDistance
        end
    else
        Data.lyfe.stepsEachSpin = Config.lyfe.steps
    end

    -- 每一步鼠标在X轴上的基础移动距离
    local baseXAxisStepDistance = math.floor(Xdistance / Config.sensitivity.noAim / Data.lyfe.stepsEachSpin)
    -- 鼠标随机移动
    if Config.mouseMove.random.enable then
        Data.lyfe.stepDistance.xAxis = Utils.randomErrorRange(baseXAxisStepDistance,
            Config.mouseMove.random.extent.xAxis)

        Data.lyfe.stepDistance.yAxis = Utils.randomNegativeToPositiveRange(Config.lyfe.yAxisErrorDistance,
            Config.mouseMove.random.extent.yAxis)
    else
        Data.lyfe.stepDistance.xAxis.min = baseXAxisStepDistance
        Data.lyfe.stepDistance.xAxis.max = baseXAxisStepDistance

        Data.lyfe.stepDistance.yAxis.min = 0
        Data.lyfe.stepDistance.yAxis.max = 0
    end
end

-- 里芙-无限之视 E技能转圈宏
function Lyfe()
    local keyboardSleep = math.random(Data.sleep.keyboard.min, Data.sleep.keyboard.max)

    PressAndReleaseKey("e")
    Sleep(keyboardSleep)

    local function spin()
        for _ = 1, Data.lyfe.stepsEachSpin do
            local XAxisDistance = math.random(Data.lyfe.stepDistance.xAxis.min, Data.lyfe.stepDistance.xAxis.max)
            local yAxisDistance = math.random(Data.lyfe.stepDistance.yAxis.min, Data.lyfe.stepDistance.yAxis.max)
            local mouseSleep = math.random(Data.sleep.mouse.min, Data.sleep.mouse.max)

            MoveMouseRelative(XAxisDistance, yAxisDistance)
            Sleep(mouseSleep)
        end
    end

    spin()
    if Config.lyfe.doubleSpin.enable then
        local XAxisDistance = math.random(Data.lyfe.doubleSpinTransitionDistance.xAxis.min,
            Data.lyfe.doubleSpinTransitionDistance.xAxis.max)
        local yAxisDistance = math.random(Data.lyfe.doubleSpinTransitionDistance.yAxis.min,
            Data.lyfe.doubleSpinTransitionDistance.yAxis.max)
        -- 在Y轴方向上移动视角
        MoveMouseRelative(XAxisDistance, yAxisDistance)
        spin()
        -- 复位
        MoveMouseRelative(-XAxisDistance, -yAxisDistance)
    end

    if Config.lyfe.autoUltimate then
        keyboardSleep = math.random(Data.sleep.keyboard.min, Data.sleep.keyboard.max)

        Sleep(keyboardSleep)
        PressAndReleaseKey("q")
    end
end

if Config.enable then
    math.randomseed(math.tointeger(GetDate("%Y%m%d%H%M%S")), GetRunningTime())

    function OnEvent(event, arg)
        if (event == "MOUSE_BUTTON_PRESSED" and arg == Config.lyfe.triggerGKey and (not Config.lockKeySwitch.enable or IsKeyLockOn(Config.lockKeySwitch.key))) then
            if (Config.lyfe.enable) then
                Lyfe()
            end
        end
    end
end
