#!/usr/bin/env python3
"""
Measures JSON decode time for each subject pack via Python's `json.load`.

This is a build-time / CI-time proxy for the runtime cost of decoding
each pack through Swift's `JSONDecoder`. Swift Decodable is typically
2–3× faster than Python `json.load` on the same payload, so a Python
budget of < 500ms per pack gives a healthy Swift budget of < 200ms
per pack at runtime.

Usage:
    python3 scripts/perf_pack_decode.py [iterations]

Defaults to 5 iterations and prints best/avg/worst per pack.
"""
import json
import os
import sys
import time

PACKS = ["science_class7", "maths_class7", "sanskrit_class7"]
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def time_pack(pack_id: str, iterations: int) -> dict:
    path = os.path.join(REPO_ROOT, "desktopAhaan", "Subjects", "Packs",
                        f"{pack_id}.json")
    deltas_ms = []
    for _ in range(iterations):
        t0 = time.perf_counter()
        with open(path, "rb") as f:
            json.loads(f.read())
        t1 = time.perf_counter()
        deltas_ms.append((t1 - t0) * 1000.0)
    return {
        "best": min(deltas_ms),
        "avg": sum(deltas_ms) / len(deltas_ms),
        "worst": max(deltas_ms),
    }


def main() -> int:
    iterations = int(sys.argv[1]) if len(sys.argv) > 1 else 5
    print(f"perf_pack_decode — {iterations} iterations per pack")
    print(f"{'pack':<20} {'best (ms)':>11} {'avg (ms)':>11} {'worst (ms)':>11}")
    print("-" * 56)
    breaches = []
    for pack_id in PACKS:
        stats = time_pack(pack_id, iterations)
        print(f"{pack_id:<20} {stats['best']:>11.1f} {stats['avg']:>11.1f} {stats['worst']:>11.1f}")
        if stats["avg"] > 500.0:
            breaches.append(f"{pack_id}: avg {stats['avg']:.1f}ms > 500ms budget")
    print()
    if breaches:
        print("BUDGET BREACH:")
        for b in breaches:
            print(f"  {b}")
        return 1
    print("All packs within 500ms Python-decode budget.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
