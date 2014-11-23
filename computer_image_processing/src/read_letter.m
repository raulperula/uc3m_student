function [letter] = read_letter(imagn)
%Computes the correlation between template and input image
%and its output is a string containing the letter.

comp = [];
patron = alphabet;

for n=1:size(patron,2)
    sem = corr2(patron(:,n), imagn);
    comp = [comp sem];
end
vd = find(comp == max(comp));

switch vd
    case 1
        letter = '0';
    case 2
        letter = '1';
    case 3
        letter = '2';
    case 4
        letter = '3';
    case 5
        letter = '4';
    case 6
        letter = '5';
    case 7
        letter = '6';
    case 8
        letter = '7';
    case 9
        letter = '8';
    case 10
        letter = '9';
    case 11
        letter = 'A';
    case 12
        letter = 'B';
    case 13
        letter = 'C';
    case 14
        letter = 'D';
    case 15
        letter = 'E';
    case 16
        letter = 'F';
    case 17
        letter = 'G';
    case 18
        letter = 'H';
    case 19
        letter = 'I';
    case 20
        letter = 'J';
    case 21
        letter = 'K';
    case 22
        letter = 'L';
    case 23
        letter = 'M';
    case 24
        letter = 'N';
    case 25
        letter = 'O';
    case 26
        letter = 'P';
    case 27
        letter = 'Q';
    case 28
        letter = 'R';
    case 29
        letter = 'S';
    case 30
        letter = 'T';
    case 31
        letter = 'U';
    case 32
        letter = 'V';
    case 33
        letter = 'W';
    case 34
        letter = 'X';
    case 35
        letter = 'Y';
    case 36
        letter = 'Z'; 
end

end
