

# --- Appended by updater: additional checks (base_dir & versions/latest) ---
if __name__ == "__main__":
    import re, sys, pathlib, yaml
    root = pathlib.Path(__file__).resolve().parents[1]
    problems = 0
    # Scan for leftover base_dir references
    for p in root.rglob("*.py"):
        try:
            txt = p.read_text(encoding="utf-8", errors="ignore")
            if "base_dir" in txt and "def base_dir" not in txt:
                print(f"[WARN] legacy base_dir reference: {p}")
                problems += 1
        except Exception:
            pass
    # Check versions/latest in accounts.yaml
    acc = root / "bridge" / "accounts.yaml"
    if acc.exists():
        data = yaml.safe_load(acc.read_text(encoding="utf-8")) or {}
        for aid, aconf in (data.get("accounts") or {}).items():
            for key in ("login_email_secret","email_secret","password_secret"):
                v = (aconf or {}).get(key, "")
                if isinstance(v, str) and "/versions/latest" not in v:
                    print(f"[WARN] {aid}:{key} not using versions/latest -> {v}")
                    problems += 1
    if problems:
        sys.exit(2)
    print("[OK] migration checks passed")
