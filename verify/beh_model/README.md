# CF_ADC_DSM20 behavioral model

`CF_ADC_DSM20_core.v` is an ideal functional model for simulation. Compile it
instead of `hdl/gl/CF_ADC_DSM20_core.v`. Do not add it to OpenLane `VERILOG_FILES`.

The protocol is assumed and is not silicon-verified. `run_tb.sh` instantiates
the wrap `CF_ADC_DSM20`. The model samples `INP` onto `dout[0]`. It does not
perform 12-to-20-bit conversion.
