tell application "iTerm"
    tell current window
        tell current session
            split horizontally with default profile
        end tell
        tell last session of last tab
                write text "z cloudnativecon17-istio-opa-demo"
        end tell
    end tell
end tell
