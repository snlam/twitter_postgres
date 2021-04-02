files='
test-data.zip
'

for file in $files; do
    # call the load_tweets.py file to load data into pg_normalized
    python3 load_tweets.py --db postgresql://postgres:pass@localhost:25430/ --inputs $file
done

for file in $files; do
    # use SQL's COPY command to load data into pg_denormalized
    unzip -p $file | sed 's/\\u0000//g' | psql postgresql://postgres:pass@localhost:15430/  -c "COPY tweets_jsonb (data) FROM STDIN csv quote e'\x01' delimiter e'\x02';"
done
