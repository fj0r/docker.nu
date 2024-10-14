export-env {
    for c in [podman nerdctl docker] {
        if (which $c | is-not-empty) {
            $env.CONTCTL = $c
            break
        }
    }
    if 'CONTCONFIG' not-in $env {
        $env.CONTCONFIG = [$nu.data-dir 'container.toml'] | path join
    }
    if not ($env.CONTCONFIG | path exists) {
        {
            preset: [
                [name, image, env, volum, port, cmd];
                [rust, 'rust', {}, {}, {}, []]
            ]

        } | to toml | save -f $env.CONTCONFIG
    }
}

export def dx [args image] {
    let image = if ($image | ststr starts-with ':') {
        let c = open $env.CONTCONFIG | get preset | where name == $image
        if ($c | is-empty) {
            $image | str substring 1..
        } else {
            $c.image
        }
    } else {
        $image
    }
}

export use core.nu *
export use registry.nu *
export use buildah.nu *
