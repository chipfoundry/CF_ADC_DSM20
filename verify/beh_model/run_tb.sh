#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${TMPDIR:-/tmp}/cf_adc_dsm20_tb"
iverilog -g2005 -o "$OUT" \
  "$ROOT/hdl/gl/CF_ADC_DSM20.v" \
  "$ROOT/verify/beh_model/CF_ADC_DSM20_core.v" \
  "$ROOT/verify/beh_model/tb_CF_ADC_DSM20.v"
vvp "$OUT"
