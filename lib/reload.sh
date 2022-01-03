while true
do
    find ./ -name '*.dart' | \
    entr -d -p ./hotreloader.sh /_
done
