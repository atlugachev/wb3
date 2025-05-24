#include <iostream>
using namespace std;

int main() {
    cout << "Введите натуральное число N: " << endl;
    int N, temp, digit, hasDuplicate = 0, sum = 0, product = 1, result;
    cin >> N;
    temp = N;

    _asm {
        // Проверяем наличие одинаковых цифр
        mov ecx, 10          // счетчик цифр (0-9)
        xor esi, esi         // обнуляем esi (флаг дубликатов)
        lea edi, hasDuplicate // адрес переменной hasDuplicate

    check_duplicates:
        xor edx, edx         // обнуляем edx перед делением
        mov eax, temp        // загружаем число
        mov ebx, 10          // делитель 10
        div ebx              // делим на 10, в edx - последняя цифра
        mov temp, eax        // сохраняем оставшуюся часть числа
        mov digit, edx       // сохраняем цифру

        // Проверяем, была ли уже такая цифра
        mov eax, 1
        shl eax, cl          // создаем маску для текущей цифры
        test esi, eax        // проверяем, был ли уже такой бит
        jz no_duplicate      // если не был, переходим
        mov dword ptr [edi], 1 // устанавливаем флаг дубликата
    no_duplicate:
        or esi, eax          // устанавливаем бит для текущей цифры
        cmp temp, 0          // проверяем, осталось ли число
        jnz check_duplicates // если да, продолжаем

        // В зависимости от наличия дубликатов выбираем действие
        cmp hasDuplicate, 0
        je calculate_product // если нет дубликатов, вычисляем произведение

    calculate_sum:
        mov temp, N          // восстанавливаем исходное число
        xor eax, eax         // обнуляем сумму
        mov sum, eax

    sum_loop:
        xor edx, edx
        mov eax, temp
        mov ebx, 10
        div ebx              // получаем последнюю цифру
        mov temp, eax
        mov digit, edx

        // Проверяем кратность 3
        mov eax, edx
        mov ebx, 3
        xor edx, edx
        div ebx
        cmp edx, 0          // проверяем остаток
        jne not_multiple
        add sum, digit       // добавляем к сумме, если кратно 3

    not_multiple:
        cmp temp, 0
        jnz sum_loop
        mov eax, sum
        mov result, eax
        jmp finish

    calculate_product:
        mov temp, N          // восстанавливаем исходное число
        mov eax, 1           // инициализируем произведение 1
        mov product, eax

    product_loop:
        xor edx, edx
        mov eax, temp
        mov ebx, 10
        div ebx              // получаем последнюю цифру
        mov temp, eax
        mov digit, edx
        imul product, digit  // умножаем на текущую цифру
        cmp temp, 0
        jnz product_loop
        mov eax, product
        mov result, eax

    finish:
        nop
    }

    cout << "Результат: " << result << endl;
    return 0;
}
