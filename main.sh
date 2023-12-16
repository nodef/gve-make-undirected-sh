#!/usr/bin/env bash
src="graph-make-undirected"
out="$HOME/Logs/$src$1.log"
ulimit -s unlimited
printf "" > "$out"

# Download program
if [[ "$DOWNLOAD" != "0" ]]; then
  rm -rf $src
  git clone https://github.com/ionicf/$src
  cd $src
fi

# Fixed config
: "${KEY_TYPE:=uint32_t}"
: "${EDGE_VALUE_TYPE:=float}"
: "${MAX_THREADS:=64}"
# Define macros (dont forget to add here)
DEFINES=(""
"-DKEY_TYPE=$KEY_TYPE"
"-DEDGE_VALUE_TYPE=$EDGE_VALUE_TYPE"
"-DMAX_THREADS=$MAX_THREADS"
)

# Build tool
g++ ${DEFINES[*]} -std=c++17 -O3 -fopenmp main.cxx

# Run tool on a single graph
runTool() {
  # $1: input file name (without extension)
  # $2: is graph weighted (0/1)
  # $3: is graph symmetric (0/1)
  opt2=""
  opt3=""
  if [[ "$2" == "1" ]]; then opt2="-w"; fi
  if [[ "$3" == "1" ]]; then opt3="-s"; fi
  stdbuf --output=L ./a.out -i "$1.mtx" -o "$1-undirected.mtx" "$opt2" "$opt3" 2>&1 | tee -a "$out"
}


# Run tool on all graphs
runTool "web-Stanford"    0 0
runTool "indochina-2004"  0 0
runTool "uk-2002"         0 0
runTool "arabic-2005"     0 0
runTool "uk-2005"         0 0
runTool "webbase-2001"    0 0
runTool "it-2004"         0 0
runTool "sk-2005"         0 0
runTool "com-LiveJournal" 0 1
runTool "com-Orkut"       0 1
runTool "asia_osm"        0 1
runTool "europe_osm"      0 1
runTool "kmer_A2a"        0 1
runTool "kmer_V1r"        0 1

# Signal completion
curl -X POST "https://maker.ifttt.com/trigger/puzzlef/with/key/${IFTTT_KEY}?value1=$src$1"
