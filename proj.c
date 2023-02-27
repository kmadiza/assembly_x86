#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int binary(void* img, int _x0, int _x1, int _y0, int _y1, int thresh);

int main() 
{
	char* buff;
	FILE *in, *out;
	unsigned int len;

	in = fopen("abc.bmp", "rb");
	if (in == NULL)
	{
		printf("File opening error!\n");
		return 1;
	}

	fseek(in, 0, SEEK_END);
	len = ftell(in);
	fseek(in, 0, SEEK_SET);

	buff = (char *)malloc(sizeof(unsigned char) * len);
	if (buff == NULL) 
	{
		printf("Memory error!\n");
		fclose(in);
		return 1;
	}

	fread(buff, len, 1, in);
	fclose(in);
	//int tresh=32;
	int thresh=90;
	int _x0=100;
	int _x1=200;
	int _y0=100;
	int _y1=200;
	
	
	int result;
	

	result=binary(buff + 54, _x0, _x1, _y0,_y1,thresh);
	out = fopen("tygrys.bmp", "wb");
	fwrite(buff, len, 1, out);
	fclose(out);
	printf("%i\n",result);
	
	
	free(buff);

	return 0;
}