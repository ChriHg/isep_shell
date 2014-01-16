url="http://www.actualites-du-net.com/feed/"

echo "sans le premier titre"
echo ""

curl -s "$url" | grep -e "<title>" | sed -e 's/<title>//g' -e 's/<\/title>//g' | sed -e '1d'

