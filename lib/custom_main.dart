import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTankApp extends StatefulWidget {
  const CustomTankApp({super.key});

  @override
  State<CustomTankApp> createState() => _CustomTankAppState();
}

class _CustomTankAppState extends State<CustomTankApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form 323 and 321 controllers
  final level323 = TextEditingController();
  final level321 = TextEditingController();
  final flowRate = TextEditingController();

  final minLevel323Ctrl = TextEditingController(text: '30');
  final minLevel321Ctrl = TextEditingController(text: '160');
  final maxLevel321Ctrl = TextEditingController(text: '634');
  final proportionIncrease323Ctrl = TextEditingController(text: '35');
  final proportionVolume321Ctrl = TextEditingController(text: '340');

  String result323321 = '';

  // Form 315 and 324 controllers
  final level315 = TextEditingController();
  final level324 = TextEditingController();
  final consumptionRate = TextEditingController();

  final transferredHeightCtrl = TextEditingController(text: '20');
  final conversionFactorCtrl = TextEditingController(text: '26');
  final controlLevel324Ctrl = TextEditingController(text: '350');
  final fullSolutionHeightCtrl = TextEditingController(text: '380');

  String result315324 = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void calculate323321() {
    final l323 = double.tryParse(level323.text) ?? 0;
    final l321 = double.tryParse(level321.text) ?? 0;
    final rate = double.tryParse(flowRate.text) ?? 1;

    final min323 = double.tryParse(minLevel323Ctrl.text) ?? 0;
    final min321 = double.tryParse(minLevel321Ctrl.text) ?? 0;
    final max321 = double.tryParse(maxLevel321Ctrl.text) ?? 0;
    final inc323 = double.tryParse(proportionIncrease323Ctrl.text) ?? 0;
    final vol321 = double.tryParse(proportionVolume321Ctrl.text) ?? 1;

    final timeToMin = (l323 - min323) / rate;
    final pumpVolume = l321 - min321;
    final increase = (inc323 / vol321) * pumpVolume;
    final newLevel = l323 + increase;
    final totalTime = (newLevel - min323) / rate;
    final nextPumping =
        DateTime.now().add(Duration(minutes: (totalTime * 60).round()));

    final fullPump = max321 - min321;
    final fullLevel = l323 + (inc323 / vol321) * fullPump;
    final fullTime = (fullLevel - min323) / rate;
    final endTime =
        nextPumping.add(Duration(minutes: (fullTime * 60).round()));

    setState(() {
      result323321 =
          'Объём перекачки: ${pumpVolume.toStringAsFixed(0)} мм\n'
          'Без перекачки: ${timeToMin.toStringAsFixed(2)} ч\n'
          'После текущей перекачки: ${totalTime.toStringAsFixed(2)} ч\n'
          'Новый уровень: ${newLevel.toStringAsFixed(2)}%\n'
          'Раствора хватит после перекачки до: '
          '${DateFormat('yyyy-MM-dd HH:mm').format(nextPumping)}\n\n'
          'После полной дозаправки: ${fullLevel.toStringAsFixed(2)}%\n'
          'Время работы после неё: ${fullTime.toStringAsFixed(2)} ч\n'
          'Раствора хватит до: ${DateFormat('yyyy-MM-dd HH:mm').format(endTime)}';
    });
  }

  void reset323321() {
    minLevel323Ctrl.text = '30';
    minLevel321Ctrl.text = '160';
    maxLevel321Ctrl.text = '634';
    proportionIncrease323Ctrl.text = '35';
    proportionVolume321Ctrl.text = '340';
  }

  void calculate315324() {
    final l315 = double.tryParse(level315.text) ?? 0;
    final l324 = double.tryParse(level324.text) ?? 0;
    final rate = double.tryParse(consumptionRate.text) ?? 1;

    final transferredHeight = double.tryParse(transferredHeightCtrl.text) ?? 1;
    final conversionFactor = double.tryParse(conversionFactorCtrl.text) ?? 1;
    final control324 = double.tryParse(controlLevel324Ctrl.text) ?? 0;
    final fullSolutionHeight = double.tryParse(fullSolutionHeightCtrl.text) ?? 0;

    final volumeToTransfer =
        (l315 - 260) / transferredHeight * conversionFactor;
    final excess = l324 - control324;
    final totalVolume = volumeToTransfer + excess;
    final timeToConsume = totalVolume / rate;
    final now = DateTime.now();
    final endTime = now.add(Duration(minutes: (timeToConsume * 60).round()));

    final fullTransfer =
        (fullSolutionHeight / transferredHeight) * conversionFactor;
    final totalWithFull = fullTransfer + excess;
    final fullTimeToConsume = totalWithFull / rate;
    final fullEndTime =
        endTime.add(Duration(minutes: (fullTimeToConsume * 60).round()));

    setState(() {
      result315324 =
          'Перекачка из 315: ${volumeToTransfer.toStringAsFixed(1)} мм\n'
          'Избыток в 324: ${excess.toStringAsFixed(1)} мм\n'
          'Общий объём: ${totalVolume.toStringAsFixed(1)} мм\n'
          'Хватит на: ${timeToConsume.toStringAsFixed(2)} ч\n'
          'Раствора хватит до: ${DateFormat('yyyy-MM-dd HH:mm').format(endTime)}\n\n'
          'Полная дозаправка (380 мм в 315): '
          '${fullTransfer.toStringAsFixed(1)} мм\n'
          'Общий объём: ${totalWithFull.toStringAsFixed(1)} мм\n'
          'Хватит на: ${fullTimeToConsume.toStringAsFixed(2)} ч\n'
          'Раствора хватит до: ${DateFormat('yyyy-MM-dd HH:mm').format(fullEndTime)}';
    });
  }

  void reset315324() {
    transferredHeightCtrl.text = '20';
    conversionFactorCtrl.text = '26';
    controlLevel324Ctrl.text = '350';
    fullSolutionHeightCtrl.text = '380';
  }

  Widget buildForm323321() {
    return Container(
      color: Colors.teal[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Уровень в 323 (%)'),
              controller: level323,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Уровень в 321 (мм)'),
              controller: level321,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Расход 323 (%/ч)'),
              controller: flowRate,
              keyboardType: TextInputType.number,
            ),
            const Divider(height: 32),
            const Text('Параметры расчёта',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              decoration: const InputDecoration(labelText: 'Минимум 323 (%)'),
              controller: minLevel323Ctrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Минимум 321 (мм)'),
              controller: minLevel321Ctrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Максимум 321 (мм)'),
              controller: maxLevel321Ctrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Увеличение 323 (%)'),
              controller: proportionIncrease323Ctrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Объём 321 при 1% в 323 (мм)'),
              controller: proportionVolume321Ctrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: calculate323321,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Рассчитать'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: reset323321,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Сброс'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(result323321, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildForm315324() {
    return Container(
      color: Colors.orange[100],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Уровень в 315 (мм)'),
              controller: level315,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Уровень в 324 (мм)'),
              controller: level324,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Скорость потребления (мм/ч)'),
              controller: consumptionRate,
              keyboardType: TextInputType.number,
            ),
            const Divider(height: 32),
            const Text('Параметры расчёта',
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Передаваемая высота (мм)'),
              controller: transferredHeightCtrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Коэффициент пересчёта'),
              controller: conversionFactorCtrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Контрольный уровень 324 (мм)'),
              controller: controlLevel324Ctrl,
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Высота полной заправки (мм)'),
              controller: fullSolutionHeightCtrl,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: calculate315324,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Рассчитать'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: reset315324,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Сброс'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(result315324, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Custom Tank App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.opacity), text: '323 и 321'),
            Tab(icon: Icon(Icons.local_drink), text: '315 и 324'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildForm323321(),
          buildForm315324(),
        ],
      ),
    );
  }
}
