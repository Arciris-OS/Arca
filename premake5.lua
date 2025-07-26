workspace "ArcirisOS"
    configurations { "Debug", "Release" }
    location "."

project "Arca"
    kind "ConsoleApp"
    language "C"
    targetdir "bin/%{cfg.buildcfg}"

    files {
        "src/**.c", "src/**.h", "include/**.h",
        "modules/litehtml/include/**.h", "modules/litehtml/src/**.c", "modules/litehtml/support**.h", "modules/litehtml/support**.c"
    }
    includedirs {
        "include",
        "modules/litehtml/include"
    }

    filter "system:linux"
        links { "X11" }

    filter "configurations:Debug"
        symbols "On"

    filter "configurations:Release"
        optimize "On"