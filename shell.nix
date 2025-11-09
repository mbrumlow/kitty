{ pkgs ? import <nixpkgs> {} }:
with pkgs;
mkShell rec {
    name = "devops";
    
    tools = [

      awscli2
      ssm-session-manager-plugin
      terraform
      
      # buf
      # gopls
      # go
      # protoc-gen-go
      # protoc-gen-go-grpc
      # cloc
      (pkgs.writeShellApplication {
        name = "claude-code";
        runtimeInputs = [ pkgs.nodejs_22 ];
        text = ''
          exec npx @anthropic-ai/claude-code "$@"
        '';
      })
    ];
    
    libs = [
      stdenv.cc.cc
    ];

    buildInputs = tools ++ libs;
    LD_LIBRARY_PATH = lib.makeLibraryPath libs;

    shellHook = ''

      export AWS_PROFILE=tf-admin
      # export GOPATH=$PWD/.gopath
      # export GOBIN=$GOPATH/bin
      # export PATH=$GOBIN:$PATH

      # export GOROOT="${go}/share/go"
      # echo "GOROOT is set to: $GOROOT"

      # mkdir -p "$GOBIN"
      # echo "Go environment set up. GOPATH is $GOPATH"
    '';
}
