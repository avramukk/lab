
package main

import "fmt"

func main() {

		// ask for user input
		var age int
		fmt.Println("Enter your age: ")
		fmt.Scanln(&age)

    if age >= 18 {
        fmt.Println("You are an adult.")
    } else {
        fmt.Println("You are not an adult yet.")
    }
}
