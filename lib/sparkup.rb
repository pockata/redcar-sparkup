module Redcar

    class Sparkup
        def initialize

			self.menus
			self.keymaps
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
		class SparkupLine < Redcar::Command
            def execute
                document = win.focussed_notebook.focussed_tab.document
                document.replace_line(document.cursor_line) do |ltext|
                    `cd #{Redcar.user_dir}/plugins/sparkup/assets && echo '#{ltext}' | sparkup/sparkup --post-tag-guides`
                end
            end
		end
    end
end
