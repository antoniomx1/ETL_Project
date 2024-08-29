class Vehicle:
    def __init__(self, make, model):
        self.make = make
        self.model = model

    def info(self):
        return f"{self.make} {self.model}"

class Car(Vehicle):
    def __init__(self, make, model, doors):
        super().__init__(make, model)
        self.doors = doors

    def info(self):
        return f"{self.make} {self.model} with {self.doors} doors"

my_car = Car("Toyota", "Camry", 4)
print(my_car.info())  # Output: Toyota Camry with 4 doors
