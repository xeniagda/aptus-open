# aptus-open

automated door opening system for chalmersstudentbostader + aptus.

## usage

```
options:
  -h, --help            show this help message and exit
  -p, --port PORT       port to listen on
  -s, --secrets-file SECRETS_FILE
                        path to secrets toml-file
```

trigger a door unlock by `POST`-requesting to `localhost:<port>/unlock-door/<door-name>`.

the secrets file contains login-details and a list of doors, see `settings.toml.sample` for details.

## nixos setup

packaged for nixos with flakes. use it like
```
  systemd.services.aptus-open = {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${aptus-open}/bin/aptus-open --secrets <path-to-secrets> -p 2138";
      Type = "simple";
      User = "aptus-open-user"; # make sure to define this user in users.users.username and make sure the user can access <path-to-secrets>
    };
  };
```
