import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PesquisaPage extends StatefulWidget {
  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    //o que falta:
    //1- toda a logica relacionada a mostrar as tarefas de cada dia
    //atenção, consegui fazer com que outros dias do calendario sejam clicaveis, mas como não mexi na logica
    //não sei se clicar neles vai trazer algo do banco de dados referente a aquele dia

    //2- ui de como aparecem as tarefas no final da pagina(ficou tarde e n deu tempo de fazer no dia 07/12, fareri dps, não se preocuopem)
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesquisa',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black12,
        iconTheme: IconThemeData(
            color: Colors.white), // Define a cor do ícone na AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCalendar(context), // Adiciona o widget do calendário
            // Implementar campos de pesquisa e exibição de resultados
          ],
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2030),
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      startingDayOfWeek: StartingDayOfWeek.sunday,
      selectedDayPredicate: (day) {
        // Verifica se o dia atual é igual ao dia selecionado
        return isSameDay(day, _selectedDay ?? DateTime.now());
      },
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        // Atualiza o estado com o dia selecionado
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      headerVisible: true,
    );
  }
}
