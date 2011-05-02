
Plugin.define do
  name    "Sparkup"
  version "0.1"
  file    "lib", "sparkup.rb"
  object  "Redcar::Sparkup"
  dependencies "application",">0",
               "edit_view" ,">0"
end