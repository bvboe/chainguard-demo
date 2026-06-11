# app.py
import time, signal, sys

import pandas as pd

signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))

def run_once(counter) -> None:
    df = pd.DataFrame(
        {
            "a": [1, 2, 3, 4],
            "b": [10, 20, 30, 40],
            "counter": counter
        }
    )
    print(df.mean(), flush=True)


if __name__ == "__main__":
    counter = 0
    while True:
        run_once(counter)
        counter = counter + 1
        time.sleep(10)
