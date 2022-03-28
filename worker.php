<?php
/**
 * A wobbly "worker" script which "runs" until it "crashes"
 */
if(getenv('FAIL', false)) {
    echo "Oh no, we cant start :(" . PHP_EOL;
    exit(1);
}

while(true) {
    echo "Working on it!" . PHP_EOL;
    sleep(3 );

    if(rand(0, 5) < 1) {
        echo "Oh no, we've hit an error :(" . PHP_EOL;
        exit(1);
    }
}
