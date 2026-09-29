`timescale 1ns / 1ps

module tb_CF_ADC_DSM20;
    reg clk;
    reg reset_b;
    reg disable_mod;
    reg sleep_drv;
    wire sleep = sleep_drv;
    reg INP;
    reg INN;
    reg VREF;
    reg SCANMODE;
    reg SCANEN;
    reg SCANINPUT;
    wire [7:0] dout;
    wire refout;
    wire SUMP_TEST;
    wire SUMN_TEST;
    wire overload_det_one;
    wire overload_det_zero;
    wire SCANOUTPUT;
    integer errors;

    CF_ADC_DSM20 dut (
        .clk(clk),
        .reset_b(reset_b),
        .disable_mod(disable_mod),
        .sleep(sleep),
        .INP(INP),
        .INN(INN),
        .VREF(VREF),
        .SCANMODE(SCANMODE),
        .SCANEN(SCANEN),
        .SCANINPUT(SCANINPUT),
        .dout(dout),
        .refout(refout),
        .SUMP_TEST(SUMP_TEST),
        .SUMN_TEST(SUMN_TEST),
        .overload_det_one(overload_det_one),
        .overload_det_zero(overload_det_zero),
        .SCANOUTPUT(SCANOUTPUT)
    );

    task tick;
        begin
            clk = 1'b0;
            #1;
            clk = 1'b1;
            #1;
        end
    endtask

    initial begin
        errors = 0;
        clk = 1'b0;
        reset_b = 1'b0;
        disable_mod = 1'b0;
        sleep_drv = 1'b0;
        INP = 1'b1;
        INN = 1'b0;
        VREF = 1'b1;
        SCANMODE = 1'b0;
        SCANEN = 1'b0;
        SCANINPUT = 1'b0;
        tick;
        if (dout !== 8'bz) begin
            $display("FAIL reset dout %b", dout);
            errors = errors + 1;
        end
        if (refout !== 1'b0 || SUMP_TEST !== 1'b0) begin
            $display("FAIL reset observes");
            errors = errors + 1;
        end
        reset_b = 1'b1;
        tick;
        if (dout !== 8'h01 || refout !== 1'b1 || SUMP_TEST !== 1'b1 || SUMN_TEST !== 1'b0) begin
            $display("FAIL run dout=%h ref=%b sump=%b sumn=%b", dout, refout, SUMP_TEST, SUMN_TEST);
            errors = errors + 1;
        end
        if (overload_det_one !== 1'b1 || overload_det_zero !== 1'b0) begin
            $display("FAIL overload");
            errors = errors + 1;
        end
        disable_mod = 1'b1;
        tick;
        if (dout !== 8'bz || refout !== 1'b0) begin
            $display("FAIL disable dout=%b ref=%b", dout, refout);
            errors = errors + 1;
        end
        disable_mod = 1'b0;
        SCANMODE = 1'b1;
        SCANEN = 1'b1;
        SCANINPUT = 1'b1;
        #1;
        if (SCANOUTPUT !== 1'b1) begin
            $display("FAIL scan");
            errors = errors + 1;
        end
        if (errors == 0) $display("PASS");
        else begin
            $display("FAIL %0d", errors);
            $fatal(1);
        end
        $finish;
    end
endmodule
