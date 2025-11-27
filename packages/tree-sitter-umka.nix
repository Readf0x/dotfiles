{ tree-sitter
, fetchFromGitHub
}:
tree-sitter.buildGrammar rec {
  language = "umka";
  version = "f2588765c45d7f5099d53cf34b46883f31407ff2";
  src = fetchFromGitHub {
    owner = "thacuber2a03";
    repo = "tree-sitter-umka";
    rev = version;
    hash = "sha256-J0CziN6nCwFRZxkt6QwfwvCDtbXa/Sqrdy3iUzrGcgo=";
  };
  meta.homepage = "https://github.com/thacuber2a03/tree-sitter-umka";
}
