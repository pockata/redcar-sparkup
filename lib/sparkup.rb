module Redcar

    class Sparkup

        @@sparkup_cmd = "sparkup/sparkup --post-tag-guides"

        def initialize

            self.menus
            self.keymaps

            unless self.hasPython
                @@sparkup_cmd = "java -jar jython/jython.jar sparkup/sparkup"
            end
        end

        # Get Sparkup's cmd
        def self.getCmd

            @@sparkup_cmd
        end

        # Shows the menu in the toolbar
        def self.menus
            Redcar::Menu::Builder.build do
                sub_menu "Plugins" do
                    sub_menu "Sparkup" do
                        item "Sparkup line", SparkupLine
                        item "Edit Sparkup", EditSparkup
                    end
                end
            end
        end

        # Makes the keybindings
        def self.keymaps
            map = Redcar::Keymap.build("main", [:osx, :linux, :windows]) do
                link "Ctrl+Shift+D", SparkupLine
            end
            [map]
        end

        # Check if Python is installed
        def self.hasPython

            if Redcar.platform == :windows

                # I haven't found a useable python test
                # Got any? Send them to me pls
                return false
            else

                pTest = `which python`
                return pTest != ''
            end
        end

        # Open Sparkup's file (this) for edit
        class EditSparkup < Redcar::Command
            def execute

                Project::Manager.open_project_for_path(
                    File.join(Redcar.user_dir, "plugins", "sparkup")
                )

                tab = Redcar.app.focussed_window.new_tab(Redcar::EditTab)
                mirror = Project::FileMirror.new(File.join(
                    Redcar.user_dir, "plugins", "sparkup", "lib", "sparkup.rb"
                ))
                tab.edit_view.document.mirror = mirror
                tab.edit_view.reset_undo
                tab.focus
            end
        end

        # Run Sparkup
        class SparkupLine < EditTabCommand
            def execute
                doc.replace_line(doc.cursor_line) do |ltext|

                    cmd = Sparkup.getCmd
                    dir = "#{Redcar.user_dir}/plugins/sparkup/assets"

                    resp = `cd #{dir} && echo '#{ltext}' | #{cmd}`
                    doc.cursor_offset = doc.cursor_line_start_offset
                    resp
                end
            end
        end
    end
end
