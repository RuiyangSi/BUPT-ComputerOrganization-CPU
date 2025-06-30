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
	output reg  ABUS,       // Enable ALU Bus
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
	localparam WRITE_REG = 3'b100, READ_REG = 3'b011, FETCH = 3'b000, READ_MEMORY = 3'b010, WRITE_MEMORY = 3'b001;
	localparam ADD    = 4'b0001, SUB    = 4'b0010, AND = 4'b0011,
	           INC    = 4'b0100, LD     = 4'b0101, ST     = 4'b0110,
	           JC     = 4'b0111, JZ     = 4'b1000, JMP    = 4'b1001,
	           STP    = 4'b1110;
	localparam W0 = 3'b000, W1 = 3'b001, W2 = 3'b010, W3 = 3'b100;
	// --- Internal State and Triggers ---
	reg FLAG;    // The 1-bit state register for STO
	reg [2:0] w;
	always @(negedge T3, negedge CLR_n) begin
		if(CLR_n == 0) begin
			LPC <= 1'b0; PCINC <= 1'b0; PCADD <= 1'b0;
			LAR <= 1'b0; ARINC <= 1'b0;
			LIR <= 1'b0;
			DRW <= 1'b0;
			LDZ <= 1'b0; LDC <= 1'b0;
			S <= 4'b0000; M <= 1'b0; CIN <= 1'b0;
			MEMW <= 1'b0; ABUS <= 1'b0; SBUS <= 1'b0; MBUS <= 1'b0;
			SEL <= 4'b0000; SELCTL <= 1'b0;
			STOP <= 1'b0; SHORT <= 1'b0; LONG <= 1'b0;
			w <= W1;
		end
		else if(w == 3'b000) begin
			LPC <= 1'b0; PCINC <= 1'b0; PCADD <= 1'b0;
			LAR <= 1'b0; ARINC <= 1'b0;
			LIR <= 1'b0;
			DRW <= 1'b0;
			LDZ <= 1'b0; LDC <= 1'b0;
			S <= 4'b0000; M <= 1'b0; CIN <= 1'b0;
			MEMW <= 1'b0; ABUS <= 1'b0; SBUS <= 1'b0; MBUS <= 1'b0;
			SEL <= 4'b0000; SELCTL <= 1'b0;
			STOP <= 1'b0; SHORT <= 1'b0; LONG <= 1'b0;
			w <= W1;
		end
		else begin
			case(SW)
				READ_REG: begin
					case(FLAG)
						1'b0: begin
							case(w)
								W1: begin SBUS <= 1; SEL <= 4'b0011; SELCTL <= 1; DRW <= 1; STOP <= 1; w <= W2; end
								W2: begin SBUS <= 1; SEL <= 4'b0100; SELCTL <= 1; DRW <= 1; STOP <= 1; FLAG <= 1; w <= W1; end
								default begin ; end
							endcase
						end
						1'b1: begin
							case(w)
								W1: begin SBUS <= 1; SEL <= 4'b1001; SELCTL <= 1; DRW <= 1; STOP <= 1; w <= W2; end
								W2: begin SBUS <= 1; SEL <= 4'b1110; SELCTL <= 1; DRW <= 1; STOP <= 1; w <= W0; LONG <= 1; end
								default begin ; end
							endcase
						end
					endcase
				end
			endcase
		end
	
		
	end
	
	
endmodule
