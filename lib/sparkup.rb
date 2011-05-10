module Redcar

    class Sparkup

        def self.plugin_dir
          File.join(File.dirname(__FILE__), "..")
        end

        # Default sparkup command, if OS has Python
        @@sparkup_cmd = "#{Sparkup.plugin_dir}/assets/sparkup/sparkup"

        def initialize

            # Set the menu item
            self.menus

            # Set the keybindings
            # TODO: Make the keybindings as a preference
            self.keymaps

            # Jython fallback if Python isn't installed
            unless self.hasPython
                @@sparkup_cmd = "java -jar #{Sparkup.plugin_dir}/jython/jython.jar #{Sparkup.plugin_dir}/assets/sparkup/sparkup"
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
                    File.join(File.dirname(__FILE__), "..")
                )

                tab = Redcar.app.focussed_window.new_tab(Redcar::EditTab)
                mirror = Project::FileMirror.new(File.join(
                    File.join(Sparkup.plugin_dir, "lib", "sparkup.rb")
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
                    dir = "#{Sparkup.plugin_dir}/assets"
                    startLine = doc.cursor_offset

                    # Run the command
                    cmd =  "cd #{dir} && echo '#{ltext}' | #{cmd}"
                    resp = `#{cmd}`

                    # Set the cursor to the start of the line
                    # TODO: Add tab positions like snippets
                    doc.cursor_offset = startLine
                    resp
                end
            end
        end
    end
end
