`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 10:26:22
// Design Name: 
// Module Name: vga_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_sync(
  input               clk_148Mhz  ,
  input               reset       , //reset asincron, activ in 1
  input               pir_signal  , // adăugat lângă celelalte inputuri
  output              h_sync      , //semnal de sincronizare pe orizontală(spune cand incepe o linie noua)
  output              v_sync      , //semnal de sincronizare pe verticală (cadru nou)
  output reg   [3:0]  red         ,
  output reg   [3:0]  green       ,
  output reg   [3:0]  blue        ,
  output reg   [0:0]  led 
 
  
 );
 
   
//parametrii orizontali
localparam HV  = 1920 ;  //horizontal visible (nr pixeli vizibili pe o linie)
localparam HFP =   88 ;  //horizontal front porch 
localparam HSP =   44 ;  //horizontal sync pulse (pt a stii cand s a terminat o linie)
localparam HBP =  148 ;  //horizontal back porch


localparam H_max     = HV + HFP + HSP + HBP-1; //2199 (nr pixeli pe o linie)


//parametrii verticali
localparam VV  = 1080 ;  //vertical visible area - zona vizibilă (1080 linii pe ecran)
localparam VFP =    4 ;  //vertical front porch  - pauză după imagine, înainte de sincronizare
localparam VSP =    5 ;  //vertical sync pulse   - durata impulsului de sincronizare verticală
localparam VBP =   36 ;  //vertical back porch   - pauză după sincronizare, înainte de imagine

localparam V_max = VV + VFP + VSP + VBP-1;  //1124 

//registrii
reg [11:0] h_count; //contor creste de la 0 la h_max
reg [11:0] v_count; //contor creste de la 0 la v_max
reg [27:0] timer; // 28 biți = suficient pentru ~3 secunde

//semnale de sincronizare
assign h_sync = (h_count >= HV + HFP) & (h_count < HV + HFP + HSP);  //orizontala
assign v_sync = (v_count >= VV + VFP) & ( v_count < VV + VFP + VSP); //verticala


//CONTOR ORIZONTAL
always @(posedge  clk_148Mhz or posedge reset) begin
    if (reset)
        h_count <= 0; 
    else if (h_count == H_max)  //h_count ajunge la sf liniei
        h_count <= 0;           //se reseteaza pentru a incepe o linie noua
    else
        h_count <= h_count + 1; 
end

// CONTOR VERTICAL
always @(posedge  clk_148Mhz or posedge reset) begin
    if (reset)
        v_count <= 0; 
    else if (h_count == H_max) begin //daca s-a terminat o linie
        if (v_count == V_max)        // si v_count a ajuns la sf cadrului
            v_count <= 0;            // se reseteaza pt a incepe un nou cadru
        else
            v_count <= v_count + 1;  // trecem la linia următoare
    end
end

// Temporizator pentru mișcare detectată
//Menține ecranul verde pentru o perioadă setată după ultima mișcare detectată.
always @(posedge clk_148Mhz or posedge reset)
if (reset) begin
    timer <= 0; // Resetare timer la 0 (starea inițială "fără mișcare").
end
else if (pir_signal) begin
    // Dacă pir_signal este HIGH (mișcare detectată)
    // reîncărcăm timer-ul la valoarea maximă
     //Aceasta resetează perioada de ~3 secunde
    timer <= 444000000;  
end
else if (timer > 0) begin 
    // Asta menține ecranul verde pentru o perioadă fixă după ce ultima mișcare
    timer <= timer - 1;
end


// zona activă: 1920x1080
assign video_on = (h_count < HV) && (v_count < VV);



always @(*) begin
if (video_on) begin
    if (timer > 0) begin
        // Fundal verde
        red   = 4'b0000;
        green = 4'b1111;
        blue  = 4'b0000;
        led <= 1'b1;
    end else begin
        // Fundal albastru
        red   = 4'b0000;
        green = 4'b0000;
        blue  = 4'b1111;
        led <= 1'b0;
    end
end else begin
    // În afara zonei vizibile (porch/sync)
    red   = 4'b0000;
    green = 4'b0000;
    blue  = 4'b0000;
end

end

//assign led = pir_signal;
endmodule

