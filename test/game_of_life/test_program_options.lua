local lu = require("luaunit")
local program_options = require("game_of_life.program_options")

TestProgramOptions = {}

function TestProgramOptions:setUp()
    self.os_exit = os.exit
    os.exit = function()
        assert(false, "trying to call os.exit")
    end
end

function TestProgramOptions:tearDown()
    os.exit = self.os_exit
end

function TestProgramOptions.test_parse()
    lu.assertEquals(program_options.parse(), {})
    lu.assertEquals(program_options.parse("ololo"), {map_module = "ololo"})
    lu.assertEquals(program_options.parse("gospers_gun"), {map_module = "gospers_gun"})
    lu.assertEquals(program_options.parse("--wrap"), {wrap = true})
    lu.assertEquals(program_options.parse("--size=10x17"), {size = {width = 10, height = 17}})
    lu.assertEquals(program_options.parse("--size=150x200"), {size = {width = 150, height = 200}})
    lu.assertEquals(program_options.parse("gospers_gun", "--size=150x200"), {map_module = "gospers_gun"})
    lu.assertEquals(program_options.parse("--size=150x200", "kek_pek"), {map_module = "kek_pek"})
    lu.assertEquals(program_options.parse("gospers_gun", "--wrap"), {map_module = "gospers_gun", wrap = true})
    lu.assertEquals(program_options.parse("--wrap", "ololo"), {map_module = "ololo", wrap = true})
    lu.assertEquals(program_options.parse("--size=200x300", "--wrap"), {size = {width = 200, height = 300}, wrap = true})
end

TestProgramOptionsInvalid = {}

function TestProgramOptionsInvalid:setUp()
    self.os_exit = os.exit
    os.exit = function()
        self.os_exit_called = true
    end
end

function TestProgramOptionsInvalid:tearDown()
    lu.assertEvalToTrue(self.os_exit_called)
    os.exit = self.os_exit
end

function TestProgramOptionsInvalid.test_parse__SingleSize()
    program_options.parse("--size=100")
end

function TestProgramOptionsInvalid.test_parse__NaNSize()
    program_options.parse("--size=KekxPek")
end

function TestProgramOptionsInvalid.test_parse__Help()
    program_options.parse("--help")
end

assert(0 == lu.LuaUnit.run())
