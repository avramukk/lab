
package main

import "fmt"

func main() {
    // Оголошення рядка
    var str string = "Hello, Go!"

    // Виведення символів рядка
    for i := 0; i < len(str); i++ {
        fmt.Println(string(str[i]))
    }
}
