class Nave {
  var velocidad
  var direccion
  var combustible

  method acelerar(numero){
    if (numero < 0) self.error("El numero debe ser positivo") 
    else velocidad = (velocidad+numero).min(100000)
  }
  method desacelerar(numero){
    if (numero < 0) self.error("El numero debe ser positivo") 
    else velocidad = (velocidad-numero).max(0)
  }

  method irHaciaElSol(){direccion =10} 
  method escaparDelSol(){direccion =-10} 
  method ponerseParaleloAlSol(){direccion =0} 
  method acercarseUnPocoAlSol(){direccion = (direccion+1).min(10)}
  method alejarseUnPocoDelSol(){direccion = (direccion-1).max(0)}

  method prepararViaje()

  method cargarCombustible(cantidad){
    if(cantidad < 0) self.error("La cantidad debe ser positiva") else combustible += cantidad
  }
  method descargarCombustible(cantidad){
    if(cantidad < 0 or combustible < cantidad) self.error("La cantidad debe ser menor al combustible total") else combustible -= cantidad
  }

  method estaTranquila() = combustible >= 4000 and velocidad <= 12000

  method recibirAmenaza()

  method estaRelajada()= self.estaTranquila()
}

class NaveBaliza inherits Nave{

  var baliza
  var cambioDeColor = false

  method cambiarColorBaliza(nuevaBaliza){
    baliza = nuevaBaliza
    cambioDeColor = true
  }

  method mostrarBaliza() = baliza.obtenerColor()

  override method prepararViaje() {
    self.cambiarColorBaliza(verde)
    self.ponerseParaleloAlSol()
    self.cargarCombustible(30000)
    self.acelerar(5000)
    }

  override method estaTranquila() = super() and baliza.obtenerColor() != "rojo"

  override method recibirAmenaza(){
    self.irHaciaElSol()
    if(baliza.obtenerColor() != "rojo") self.cambiarColorBaliza(rojo)
  }

  method cambioDeColor() = cambioDeColor

  override method estaRelajada() = super() and self.cambioDeColor()
}

//Es posible crear una clase "Color" y que verde, rojo y azul la hereden. No lo considero necesario.

object verde{
  method obtenerColor() = "verde"
}
object rojo{
  method obtenerColor() = "rojo"
}
object azul{
  method obtenerColor() = "azul"
}

class NaveDePasajeros inherits Nave{
  var cantidadPasajeros
  var racionComida
  var racionBebida
  var comidaServida

  method cargarComida(cantidad){if(cantidad < 0) self.error("La cantidad debe ser positiva") else racionComida += cantidad}
  method cargarBebida(cantidad){if(cantidad < 0) self.error("La cantidad debe ser positiva") else racionBebida += cantidad}
  method descargarComida(cantidad){if(cantidad < 0 or racionComida < cantidad) self.error("La cantidad debe ser menor a la racion total") 
        else racionComida -= cantidad
        comidaServida += cantidad
  }
  method descargarBebida(cantidad){if(cantidad < 0 or racionBebida < cantidad) self.error("La cantidad debe ser menor a la racion total") else racionBebida -= cantidad}

  override method prepararViaje(){
    self.cargarComida(cantidadPasajeros*4)
    self.cargarBebida(cantidadPasajeros*6)
    self.acercarseUnPocoAlSol()
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }

  override method recibirAmenaza(){
    self.acelerar(velocidad*2)
    self.descargarComida(cantidadPasajeros)
    self.descargarBebida(cantidadPasajeros*2)
  }

  override method estaRelajada() = super() and comidaServida < 50
}

class NaveDeCombate inherits Nave{
  var esInvisible = false
  var misilDesplegado = false
  const mensajes = []

  method ponerseVisible(){esInvisible = false}
  method ponerseInvisible(){esInvisible = true}
  method estaInvisible() = esInvisible
  method desplegarMisiles(){misilDesplegado = true}
  method replegarMisiles(){misilDesplegado = false}
  method misilesDesplegados() = misilDesplegado
  method emitirMensaje(mensaje){mensajes.add(mensaje)}
  method mensajesEmitidos() = mensajes
  method primerMensajeEmitido() = mensajes.first()
  method ultimoMensajeEmitido() = mensajes.last()
  method esEscueta() = mensajes.any({m=> not (m.length() > 30)})
  method emitioMensaje(mensaje) = mensajes.contains(mensaje)

  override method prepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
    self.ponerseVisible()
    self.desplegarMisiles()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en misión")
  }

  override method estaTranquila() = super() and !self.misilesDesplegados()

  override method recibirAmenaza(){
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
    self.emitirMensaje("Amenaza recibida")
  }
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
  override method estaTranquila() = super() and !self.estaInvisible()

  override method recibirAmenaza(){
    super()
    if(!self.misilesDesplegados()) self.desplegarMisiles()
    if(!self.estaInvisible()) self.ponerseInvisible()
  }
}

class NaveHospital inherits NaveDePasajeros{
  var quirofanosEstanDisponibles = false
  method cambiarDisponibilidadDeQuirofanos() {quirofanosEstanDisponibles = not quirofanosEstanDisponibles}
  method quirofanosPreparados() = quirofanosEstanDisponibles
  override method estaTranquila() = super() and !quirofanosEstanDisponibles

  override method recibirAmenaza(){
    super()
    if(!self.quirofanosPreparados()) self.cambiarDisponibilidadDeQuirofanos()
  }
}