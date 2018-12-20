// cad_cas.cpp : Defines the entry point for the console application.
//

//#include "stdafx.h"

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

using namespace std;

int W = 160;
int H = 120;

int read_sram(char sram_init[], unsigned int * sram, int size); // sram[i]: 16 bit is valid.((data[7:0]) + (data[7:0]<<8))
int write_image(char output_filename[], unsigned int * rgb); // rgb[i]: 24 bit is valid. (r + (g<<8) + (b<<16) )
void yuv_to_rgb(unsigned int *  sram, unsigned int * rgb); // sram and rgb 
void upsampling(unsigned int *  sram, unsigned int *  tempSram);//Upsampling and build sram for prev project.
void writeOutPut(char output_filename[],unsigned int * tempSram, int size);
void idct(unsigned int* sram, unsigned int* tempsram);
void IDCT8x8(int St[8][8], int S[8][8]);

int main(void) {
	// printf("%d\n", -1 << 3); // 8
	unsigned int * sram, *rgb, *upsampleSram, *idctSram;
	char fileName[50] = "ca6_tehran_small.hex";
	char outputFileName[50] = "result_file.bmp";
	char UpsampleOutFileName[50] = "upsampling.hex";
	char IdctOutFileName[50] = "idct.hex";
	
	sram = (unsigned int *)malloc(W*H*2 * sizeof(unsigned int));
	upsampleSram = (unsigned int *)malloc(W*H*3/2 * sizeof(unsigned int));
	idctSram = (unsigned int *)malloc(W*H * sizeof(unsigned int));
	rgb = (unsigned int *)malloc(W*H * sizeof(unsigned int));
	
	read_sram(fileName, sram, W*H*2);
	printf("read sram done.\n");
	
	idct(sram, idctSram);
	printf("idct done.\n");
	
	writeOutPut(IdctOutFileName,idctSram, W*H);
	
	upsampling(idctSram, upsampleSram);
	printf("upsampling done.\n");
	
	writeOutPut(UpsampleOutFileName,upsampleSram, W*H*3/2);
	
	yuv_to_rgb(upsampleSram, rgb);
	printf("yuv to rgb done.\n");

	write_image(outputFileName, rgb);
	printf("write image done.\n");

	free(idctSram);
	free(upsampleSram);
	free(sram);
	free(rgb);
	return 0;

}

void IDCT8x8(int St[8][8], int S[8][8]){
	int i , j, k;
	int temp[8][8] ;
	int C[8][8] = { {1448,        1448,        1448,        1448,        1448,        1448,        1448,        1448},
					{2008,        1702,        1137,		399,        -400,       -1138,       -1703,       -2009},
					{1892,         783,        -784,       -1893,       -1893,        -784,         783,        1892},
					{1702,        -400,       -2009,       -1138,        1137,        2008,         399,       -1703},
					{1448,       -1449,       -1449,        1448,        1448,       -1449,       -1449,        1448},
					{1137,       -2009,         399,        1702,       -1703,        -400,        2008,       -1138},
					{ 783,       -1893,        1892,        -784,        -784,        1892,       -1893,         783},
					{ 399,       -1138,        1702,       -2009,        2008,       -1703,        1137,        -400}};
					
	int Cprime[8][8] = {{ 1448, 2008, 1892, 1702, 1448, 1137, 783, 399 },
						{ 1448, 1702, 783, -400, -1449, -2009, -1893, -1138 },
						{ 1448, 1137, -784, -2009, -1449, 399, 1892, 1702 },
						{ 1448, 399, -1893, -1138, 1448, 1702, -784, -2009 },
						{ 1448, -400, -1893, 1137, 1448, -1703, -784, 2008 },
						{ 1448, -1138, -784, 2008, -1449, -400, 1892, -1703 },
						{ 1448, -1703, 783, 399, -1449, 2008, -1893, 1137 },
						{ 1448, -2009, 1892, -1703, 1448, -1138, 783, -400 }};

	for (int i=0; i < 8; i++)
	{
		for (int j = 0; j < 8; j++)
		{
			temp[i][j] = 0;
			for (int k = 0; k < 8; k++)
			{
				temp[i][j] += (St[i][k] * C[k][j] );
			}
			temp[i][j] = temp[i][j] >> 8;
		}
	}

	for (int i=0; i < 8; i++)
	{
		for (int j = 0; j < 8; j++)
		{
			S[i][j] = 0;
			for (int k = 0; k < 8; k++)
			{
				S[i][j] += Cprime[i][k] * temp[k][j];
			}
			S[i][j] = S[i][j] >> 16;
			if (S[i][j] < 0) S[i][j] = 0;
			if (S[i][j] > 255) S[i][j] = 255;
			// cout << S[i][j] << endl;
		}
	}

	// ...
	
	//Calculate Ct*(temp) >>16 and saturate final result to range 0-255
	// ...
}
void idct(unsigned int* sram, unsigned int* tempsram){
	int i , j,k, h, w;
	int offset;
	int St[8][8] ;
	int S[8][8] ;
	int index = 0;
	// For Y
	for (h=0;h<H;h=h+8){
		for (w=0;w<W;w=w+8){
			//Extract one block
			for (i=0;i<8;i++){
				for(j=0;j<8;j++){
					St[i][j] = ((signed short int)sram[index + i*8 + j]);
					// cout << St[i][j] << endl;
				}
			}
			// Calculate IDCT for 8*8 Block
			IDCT8x8(St,S);
			
			for (int i = 0; i < 8; i++)
				for (int j = 0; j < 8; j +=2)
				{
					tempsram[h * 80 + w / 2 + i * 80 + (j / 2)] = (S[i][j]) + (S[i][j+1] << 8);
					// cout << h * 80 + w / 2 + i * 80 + (j / 2) << endl;
					// tempsram[index / 2 + i * 4 + j / 2] = (S[i][j] << 8) + (S[i][j+1]);
					// cout << S[i][j] + (S[i][j+1] << 8) << endl;
					// cout << index / 2 + i * 4 + j / 2 << endl;
				}
			index+=64;
			//Write one block to sram
			// ...
		}
	}
	
	// For U and V
	offset = W*H;
	for (h=0;h<2*H;h=h+8){
		for (w=0;w<W/2;w=w+8){
			//Extract one block
			for (i=0;i<8;i++){
				for(j=0;j<8;j++){
					St[i][j] = (signed short int)sram[index + i*8 + j];
				}
			}
			// Calculate IDCT for 8*8 Block
			IDCT8x8(St,S);
			
			for (int i = 0; i < 8; i++)
				for (int j = 0; j < 8; j += 2)
				{
					tempsram[offset / 2 + h * 40 + w / 2 + i * 40 + (j / 2)] = (S[i][j]) + (S[i][j+1] << 8);
					cout << offset / 2 + h * 40 + w / 2 + i * 40 + (j / 2) << endl;
					// tempsram[index / 2 + i * 4 + j / 2] = (S[i][j] << 8) + (S[i][j+1]);
					// cout << S[i][j] + (S[i][j+1] << 8) << endl;
					// cout << index / 2 + i * 4 + j / 2 << endl;
				}
			index+= 64;
			//Write one block to sram
			// ...
		}
	}
}
void writeOutPut(char output_filename[], unsigned int * tempSram, int size) {
	
	FILE *fp;
	fp = fopen(output_filename, "wb");
	for (int i = 0; i < size; i++)
	{
		fprintf(fp, "%.4x\n", tempSram[i]);
	}
	fclose(fp);
}

void upsampling(unsigned int *  sram, unsigned int *  tempSram) {
	int i, j, h;
	int sample0, sample1, sample2, sample3, sample4, sample5;
	int newData;
	int tempData1, tempData2;
	int onerow[W/2 + 5];
	int onerow_new[W];
	int w;
	//just copy Y values to temporary sram
	for (i = 0; i <= (W*H/2 -1); i++)
	{
		tempSram[i] = sram[i];
	}
	//Upsampling on U and V values
	for(h=0; h< H*2 ; h++){// for u and v
		// Extract one row 
		for(w=0 ; w<W/4 ; w++){
			onerow[2*w+2] = sram[W*H/2 + h*W/4 + w] & 0x00ff;
			onerow[2*w+2+1] = sram[W*H/2 + h*W/4 + w]>>8;
		}
		
		// Extended start and end of row
		onerow[0] = onerow[2];
		onerow[1] = onerow[2];
		onerow[W/2+2] = onerow[W/2+1];
		onerow[W/2+3] = onerow[W/2+1];
		onerow[W/2+4] = onerow[W/2+1];
		
		// Upsampling for one row
		for (w=0;w<W;w++){
			if(!(w%2))
				onerow_new[w] = onerow[w/2+2];
			else
				onerow_new[w] =(21*onerow[w/2] - 52*onerow[w/2+1] + 159*onerow[w/2+2] + 159*onerow[w/2+3] -52*onerow[w/2+4] +21*onerow[w/2+5] + 128) / 256;
			//onerow_new[w] = onerow_new[w] > 255 ? 255: (onerow_new[w] <0 ? 0 : onerow_new[w]);
		}
		
		// Write one row in sram
		for (i = 0; i <= W/2; i++)
		{
			tempSram[W*H/2 + h*W/2 + i] = onerow_new[2*i] + (onerow_new[2*i+1]<<8);
		}
	
	}
	
}


void yuv_to_rgb(unsigned int *  sram, unsigned int * rgb) { // sram and rgb 
	int h, w;
	int yy, uu, vv;
	int y, u, v;
	int rt, gt, bt;
	// Offset of R, G and B color in SRAM
	int yy_offset = 0;
	int uu_offset = H * W / 2;
	int vv_offset = H * W;

	for (h = 0; h<H; h++)
		for (w = 0; w<W; w = w + 2) {
			// Get Y2Y1
			yy = sram[yy_offset + (h*W + w) / 2];

			// Get U2U1
			uu = sram[uu_offset + (h*W + w) / 2];

			// Get V2V1
			vv = sram[vv_offset + (h*W + w) / 2];

			// Extract Y1,U1 and V1
			y = (yy & 0x00ff) - 16;
			u = (uu & 0x00ff) - 128;
			v = (vv & 0x00ff) - 128;
	
			// R1 calculated
			rt = ((y * 76284) + (u * 0) + (v * 104595)) / 65536;
			rt = rt > 255 ? 255 : (rt < 0 ? 0 : rt);
			
			// G1 calculated
			gt = ((y * 76284) - (u * 25624) - (v * 53281)) / 65536;
			gt = gt > 255 ? 255 : (gt < 0 ? 0 : gt);
			
			// B1 calculated
			bt = ((y * 76284) + (u * 132251) + (v * 0)) / 65536;
			bt = bt > 255 ? 255 : (bt < 0 ? 0 : bt);
			
			// Set RGB1
			rgb[h*W + w] = rt + (gt << 8) + (bt << 16);
			
			// Extract Y2,U2 and V2
			y = (yy >> 8) - 16;
			u = (uu >> 8) - 128;
			v = (vv >> 8) - 128;
			
			// R2 calculated
			rt = ((y * 76284) + (u * 0) + (v * 104595)) / 65536;
			rt = rt > 255 ? 255 : (rt < 0 ? 0 : rt);
			
			// G2 calculated
			gt = ((y * 76284) - (u * 25624) - (v * 53281)) / 65536;
			gt = gt > 255 ? 255 : (gt < 0 ? 0 : gt);
			
			// B2 calculated
			bt = ((y * 76284) + (u * 132251) + (v * 0)) / 65536;
			bt = bt > 255 ? 255 : (bt < 0 ? 0 : bt);
			
			// Set RGB2
			rgb[h*W + w + 1] = rt + (gt << 8) + (bt << 16);

		}
}

int write_image(char output_filename[], unsigned int * rgb) { // rgb[i]: 24 bit is valid. (r + (g<<8) + (b<<16) )
	int i, h, w;
	FILE *fp;
	unsigned char header[54];

	// Initialize header of bmp to zero.
	for (i = 0; i<54; i++)
		header[i] = 0;
	// Initialize header of bmp file.
	header[0] = 0x42;
	header[1] = 0x4d;
	header[2] = 0x36;
	header[3] = 0x84;
	header[4] = 0x01;
	header[10] = 0x36;
	header[14] = 0x28;
	header[18] = W;
	header[19] = W >> 8;
	header[20] = W >> 16;
	header[21] = W >> 24;
	header[22] = H;
	header[23] = H >> 8;
	header[24] = H >> 16;
	header[25] = H >> 24;
	header[26] = 0x01;
	header[28] = 0x18;
	header[35] = 0x84;
	header[36] = 0x03;

	fp = fopen(output_filename, "wb");

	if (!fp) {
		printf("Can not create bmp file for output.");
	}
	// Write header of bmp file.
	for (i = 0; i<54; i++) {
		fprintf(fp, "%c", header[i]);
	}

	// Write RGB 
	// These are the actual image data, represented by consecutive rows, or "scan lines," of the bitmap. 
	// Each scan line consists of consecutive bytes representing the pixels in the scan line, in left-to-right order. 
	// The system maps pixels beginning with the bottom scan line of the rectangular region and ending with the top scan line.
	for (h = 0; h<H; h++)
		for (w = 0; w<W; w++)
			fprintf(fp, "%c%c%c", rgb[(H - h - 1)*W + w] >> 16, rgb[(H - h - 1)*W + w] >> 8, rgb[(H - h - 1)*W + w]);
	fclose(fp);
}

int read_sram(char sram_init_filename[], unsigned int  * sram, int size) { // sram[i]: 16 bit is valid.((data[7:0]) + (data[7:0]<<8))

	int i;
	FILE *fp;
	fp = fopen(sram_init_filename, "r");
	if (!fp) {
		printf("File name for SRAM_INIT not valid.");
		return 0;
	}

	//sram = (unsigned int *)malloc(size*sizeof(unsigned int));
	for (i = 0; i<size; i++) {
		fscanf(fp, "%x", &sram[i]);
		// cout << sram[i] << endl;
	}
	return 1;
}



// ((NewArray) $exp).setExpression(new IntValue(Integer.parseInt($const_num.text), new IntType())); // tell TA: test7