#!/usr/bin/env bash
# Default option values.
: "${PREFIX:=~/.local}"
HELP="0"


# Parse options.
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      HELP="1"
      shift
      ;;
    -p|--prefix)
      PREFIX="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done


# Print help message.
if [[ "$HELP" == "1" ]]; then
  echo "Usage: ./install.sh [options]"
  echo "Options:"
  echo "  -h, --help      Print this message and exit."
  echo "  -p, --prefix    Install prefix (default: ~/.local)."
  exit 0
fi


# Install program.
mkdir -p "$PREFIX/bin"
echo "Compiling gve-make-undirected.sh ..."
DOWNLOAD=0 RUN=0 ./main.sh
echo "Done."
printf "\n"
echo "Installing gve-make-undirected.sh ..."
mv a.out "$PREFIX/bin/gve-make-undirected"
echo "Done."
printf "\n"
