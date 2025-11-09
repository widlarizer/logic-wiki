# Foo2: Advanced Implementation

Foo2 extends the basic approach with advanced features {cite}`jones2019`.

## Enhanced Architecture

The enhanced design supports pipelining:

| Stage | Function | Latency |
|-------|----------|---------|
| 1     | Input    | 0 clk   |
| 2     | Process  | 1 clk   |
| 3     | Output   | 1 clk   |

## Code Example

```verilog
module foo2 #(
    parameter WIDTH = 16
) (
    input wire clk,
    input wire [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);
    reg [WIDTH-1:0] stage1;
    always @(posedge clk) begin
        stage1 <= in;
        out <= stage1;
    end
endmodule
```

The techniques used here are based on {cite}`jones2019`.

```{only} wiki
## References

```{bibliography}
:filter: False
```
```
