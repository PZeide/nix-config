{
  config,
  lib,
  ...
}: {
  options.zeide.programs.starship = with lib; {
    enableNerdIcons = mkEnableOption "starship nerd icons (a nerd-symbols compatible font is required)";
  };

  config = let
    selfConfig = config.zeide.programs.starship;
  in
    lib.mkIf selfConfig.enableNerdIcons {
      programs.starship.settings = {
        # Brands / Langs
        aws.symbol = " ";
        azure.symbol = " ";
        buf.symbol = " "; # no dedicated buf icon
        bun.symbol = " ";
        c.symbol = " ";
        cmake.symbol = " ";
        cobol.symbol = " "; # no dedicated cobol icon
        conda.symbol = " "; # no dedicated conda icon
        crystal.symbol = " ";
        daml.symbol = "󰫮 "; # no dedicated daml icon
        dart.symbol = " ";
        deno.symbol = " ";
        direnv.symbol = "󰵮 "; # no dedicated direnv icon
        docker_context.symbol = " ";
        dotnet.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        erlang.symbol = " ";
        fennel.symbol = " ";
        gcloud.symbol = "󱇶 ";
        gleam.symbol = "󰦥 "; # no dedicated gleam icon
        golang.symbol = "";
        guix_shell.symbol = " ";
        gradle.symbol = " ";
        haskell.symbol = " ";
        haxe.symbol = " ";
        helm.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        kotlin.symbol = " ";
        kubernetes.symbol = " ";
        lua.symbol = " ";
        meson.symbol = "󰔷 "; # no dedicated meson icon
        mojo.symbol = " "; # no dedicated mojo icon
        nats.symbol = "󰬕 "; # no dedicated nats icon
        nim.symbol = " ";
        nix_shell.symbol = " ";
        nodejs.symbol = " ";
        ocaml.symbol = " ";
        odin.symbol = "󱃓 "; # no dedicated odin icon
        opa.symbol = " "; # no dedicated opa icon
        openstack.symbol = " ";
        package.symbol = "󰏗 ";
        perl.symbol = " ";
        php.symbol = " ";
        pulumi.symbol = " ";
        purescript.symbol = " ";
        python.symbol = " ";
        quarto.symbol = "⨁ "; # no dedicated quarto icon
        rlang.symbol = " ";
        raku.symbol = " "; # no dedicated raku icon
        red.symbol = "󱥒 "; # no dedicated red icon
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        solidity.symbol = " ";
        spack.symbol = " ";
        swift.symbol = " ";
        terraform.symbol = " ";
        typst.symbol = " ";
        vagrant.symbol = " ";
        vlang.symbol = " ";
        zig.symbol = " ";

        # Source Control
        fossil_branch.symbol = " ";
        git_branch.symbol = " ";
        git_commit.tag_symbol = "  ";
        hg_branch.symbol = " ";
        pijul_channel.symbol = " ";

        # System / Misc
        battery = {
          full_symbol = "󱊣";
          charging_symbol = "󰂄";
          discharging_symbol = "󰁿";
          unknown_symbol = "󰂑";
          empty_symbol = "󰂎";
        };

        container.symbol = "";
        directory.read_only = " 󱪨";
        hostname.ssh_symbol = " ";
        jobs.symbol = "";
        memory_usage.symbol = "";
        shlvl.symbol = "󰹹 ";

        status = {
          symbol = "✖";
          not_executable_symbol = "";
          not_found_symbol = "";
          sigint_symbol = "";
          signal_symbol = "󱐋";
        };

        sudo.symbol = "󰨒 ";

        # OS icons
        os.symbols = {
          AlmaLinux = " ";
          Alpine = " ";
          Amazon = " ";
          Android = " ";
          Arch = " ";
          Artix = " ";
          CentOS = " ";
          Debian = " ";
          EndeavourOS = " ";
          Fedora = " ";
          FreeBSD = " ";
          Garuda = "󰛓 ";
          Gentoo = " ";
          Illumos = " ";
          Kali = " ";
          Linux = " ";
          Macos = " ";
          Manjaro = " ";
          Mint = " ";
          NixOS = " ";
          Nobara = " ";
          OpenBSD = " ";
          openSUSE = " ";
          Pop = " ";
          Raspbian = " ";
          Redhat = " ";
          RedHatEnterprise = " ";
          RockyLinux = " ";
          Solus = " ";
          SUSE = " ";
          Ubuntu = " ";
          Void = " ";
          Unknown = " ";
          Windows = "󰍲 ";

          # Missing OS icons: AIX, Alpaquita, Bluefin, CachyOS, DragonFly, Emscripten, HardenedBSD, Mabox
          # Mariner, MidnightBSD, NetBSD, OpenCloudOS, openEuler, OracleLinux, Redox, Ultramarine, Uos
        };

        # NO: env_var, singularity, vcsh
      };

      stylix.targets.starship.enable = true;
    };
}
