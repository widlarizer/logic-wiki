# Foo1: Basic Implementation

Foo1 represents the basic implementation approach {cite}`smith2020`.

## Architecture

The following table summarizes the key parameters:

| Parameter | Value | Description |
|-----------|-------|-------------|
| Width     | 8-bit | Data width  |
| Latency   | 1 clk | Pipeline delay |

## Implementation

```verilog
module foo1 (
    input wire clk,
    input wire rst,
    output reg valid
);
    always @(posedge clk) begin
        if (rst) valid <= 1'b0;
        else valid <= 1'b1;
    end
endmodule
```

This approach is described in detail by {cite}`smith2020` and {cite}`jones2019`.

````{only} wiki
## References

```{footbibliography}
```
````
