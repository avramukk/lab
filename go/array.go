
package main

import "fmt"

func main() {
    // Оголошення масиву
    var numbers [5]int

    // Ініціалізація масиву
    numbers = [5]int{1, 2, 3, 4, 5}

    // Виведення елементів масиву
    for i := 0; i < len(numbers); i++ {
        fmt.Println(numbers[i])
    }
}
