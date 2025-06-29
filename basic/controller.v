module controller(
	// ---------------- INPUTS ----------------
	// --- Control & Status Inputs ---
	input       CLR_n,      // Reset signal (active low, from CLR#)
	input       C,          // Status flag: Carry
	input       Z,          // Status flag: Zero

	// --- Instruction & Mode Inputs ---
	input [7:4] IR,         // Instruction Register bits for opcode (IR7-IR4)
	input [2:0] SW,         // Manual operation mode switches (SWC, SWB, SWA)

	// --- Timing Inputs ---
	input       T3,         // Timing signal T3
	input [2:0] W,          // Beat signals (W3, W2, W1)


	// ---------------- OUTPUTS ----------------
	// --- PC (Program Counter) Control ---
	output reg  LPC,        // Load Program Counter
	output reg  PCINC,      // Program Counter Increment
	output reg  PCADD,      // Program Counter Add offset (for branches)

	// --- AR (Address Register) Control ---
	output reg  LAR,        // Load Address Register
	output reg  ARINC,      // Address Register Increment

	// --- IR (Instruction Register) Control ---
	output reg  LIR,        // Load Instruction Register

	// --- General Purpose Register Control ---
	output reg  DRW,        // Data Register Write enable (for R0-R3)

	// --- Status Flag Control ---
	output reg  LDZ,        // Load Z flag
	output reg  LDC,        // Load C flag

	// --- ALU Control ---
	output reg [3:0] S,     // ALU function select (S3-S0)
	output reg  M,          // ALU mode (1 for Logic, 0 for Arithmetic)
	output reg  CIN,        // Carry In for ALU

	// --- Memory & Bus Control ---
	output reg  MEMW,       // Memory Write enable
	output reg  ABUS,       // Enable Address Bus
	output reg  SBUS,       // Enable Switch Data Bus
	output reg  MBUS,       // Enable Memory Data Bus
	
	// --- MUX (Selector) Control ---
	output reg [3:0] SEL,   // Selector inputs (SEL3-SEL0)
	output reg  SELCTL,     // Selector enable

	// --- Timing & State Control ---
	output reg  STOP,       // Stop machine operation
	output reg  SHORT,      // Short machine cycle
	output reg  LONG        // Long machine cycle
);
	
	// Controller's combinational and sequential logic goes here
	
endmodule
