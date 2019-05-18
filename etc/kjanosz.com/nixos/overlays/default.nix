self: super:

import ./all.nix { ulib = (import ../lib.nix super); } self super
