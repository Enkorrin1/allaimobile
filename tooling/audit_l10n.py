import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
L10N_DIR = ROOT / "lib" / "l10n"


def message_keys(payload: dict[str, object]) -> set[str]:
    return {
        key
        for key in payload
        if not key.startswith("@") and key != "@@locale"
    }


def main() -> None:
    arb_files = sorted(L10N_DIR.glob("app_*.arb"))
    if not arb_files:
        raise SystemExit("No ARB files found.")

    payloads = {
        path.name: json.loads(path.read_text(encoding="utf-8"))
        for path in arb_files
    }
    template_name = "app_en.arb"
    template = payloads[template_name]
    template_keys = message_keys(template)

    problems: list[str] = []
    for name, payload in payloads.items():
        keys = message_keys(payload)
        missing = sorted(template_keys - keys)
        extra = sorted(keys - template_keys)
        empty = sorted(
            key for key in keys if isinstance(payload[key], str) and not payload[key]
        )
        if missing:
            problems.append(f"{name}: missing {missing}")
        if extra:
            problems.append(f"{name}: extra {extra}")
        if empty:
            problems.append(f"{name}: empty {empty}")

    if problems:
        raise SystemExit("\n".join(problems))

    print(f"OK: {len(payloads)} ARB files, {len(template_keys)} messages.")


if __name__ == "__main__":
    main()
