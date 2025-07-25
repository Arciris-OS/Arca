workspace "ArcirisOS"
    configurations { "Debug", "Release" }
    location "."

project "Arca"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"

    files { "src/**.c", "src/**.h", "include/**.h" }
    includedirs { "include" }

    filter "system:linux"
        links { "X11" }

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"