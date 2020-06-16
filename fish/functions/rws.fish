function rws
    if test (count $argv) -lt 1
        echo "ws requires a workspace argument"
        return 1
    end
    if not type -q bass
        echo "Need 'bass' plugin for fish shell installed"
        return 1
    end

    set rosdistros (ls -1 /opt/ros)
    set workspace $argv[1]

    # Check if sourcing a distro rather than a workspace
    if contains $workspace $rosdistros
        echo "Setting '$workspace' distro env"
        __rws_source_setup $workspace /opt/ros/$workspace/setup.bash
        return 0
    end


    set workspace_dir ~/Workspaces/$workspace
    if not test -d $workspace_dir
        echo "No workspace at $workspace_dir found"
        return 1
    end

    set space ""
    if set -q argv[2] # See if user passed a space arg
        set space $argv[2]
        if not test -d $workspace_dir/$space
            echo "Requested sourcing space '$space' not found in '$workspace_dir'"
            return 1
        end
    else # otherwise check for existing space, defaulting to 'install'
        if test -d $workspace_dir/install
            set space "install"
        else if test -d $workspace_dir/devel
            echo "No install space found, using devel space instead"
            set space "devel"
        else
            echo "No install or devel space found in $workspace_dir"
            return 1
        end
    end

    echo "Setting '$space' space in workspace '$workspace'"
    __rws_source_setup $workspace $workspace_dir/$space/setup.bash
end

#Actually source the ROS workspace
function __rws_source_setup
    # Redefine the prompt with ROS workspace info
    # defined here so it only happens if this function runs
    function fish_prompt
        echo "[ROS: $ROS_WORKSPACE workspace] "(prompt_pwd)"> "
    end

    set -g ROS_WORKSPACE $argv[1]
    bass source $argv[2]

    # For ROS1 only, need to source rosfish file to get command line tools
    set ros1distros "kinetic" "melodic" "noetic"
    if contains $ROS_DISTRO $ros1distros
        source /opt/ros/$ROS_DISTRO/share/rosbash/rosfish
    end
end

