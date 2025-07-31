import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/subscription_model_authview.dart';
import 'package:healthmvp/models/subscriptionModel/subscription_model.dart';
import 'package:provider/provider.dart';

class SubscriptionBottomSheet extends StatefulWidget {
  final Function(SubscriptionType) onSubscribe;
  final VoidCallback onClose;

  const SubscriptionBottomSheet({
    Key? key,
    required this.onSubscribe,
    required this.onClose,
  }) : super(key: key);

  @override
  _SubscriptionBottomSheetState createState() =>
      _SubscriptionBottomSheetState();
}

class _SubscriptionBottomSheetState extends State<SubscriptionBottomSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPlanIndex = 0;
  SubscriptionModelAuthview? subscriptionautview;

  @override
  void initState() {
    super.initState();
    subscriptionautview = Provider.of<SubscriptionModelAuthview>(
      context,
      listen: false,
    );
    subscriptionautview?.getdashboarddata(context);
    subscriptionautview?.initializeRazorpay();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    subscriptionautview = Provider.of<SubscriptionModelAuthview>(context);

    if (subscriptionautview == null ||
        subscriptionautview!.subscriptionloading) {
      return Center(child: CircularProgressIndicator());
    }

    final plans =
        subscriptionautview!.subscriptionmodel?.data.subscriptionTypes ?? [];

    if (_tabController.length != plans.length) {
      _tabController.dispose();
      _tabController = TabController(length: plans.length, vsync: this);
      _tabController.addListener(() {
        if (!_tabController.indexIsChanging) {
          final newIndex = _tabController.index;
          if (plans[newIndex].price == 0) {
            // Prevent selecting free plan
            _tabController.index = _selectedPlanIndex;
          } else {
            setState(() {
              _selectedPlanIndex = newIndex;
            });
          }
        }
      });

      // Set default index to first non-free plan
      final firstPaidIndex = plans.indexWhere((plan) => plan.price > 0);
      if (firstPaidIndex != -1) {
        _tabController.index = firstPaidIndex;
        _selectedPlanIndex = firstPaidIndex;
      }
    }

    if (plans.isEmpty) {
      return Center(child: Text("No plans available."));
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 16),
          _buildPlanSelector(plans),
          SizedBox(height: 24),
          _buildSelectedPlanDetails(plans[_selectedPlanIndex]),
          SizedBox(height: 24),
          _buildFeaturesList(plans[_selectedPlanIndex]),
          SizedBox(height: 32),
          _buildSubscribeButton(plans[_selectedPlanIndex]),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                "None Refundable!",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '         ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Choose a Plan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(icon: Icon(Icons.close), onPressed: widget.onClose),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Select the plan that works best for you',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelector(List<SubscriptionType> plans) {
    return Center(
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              plans.length,
              (index) => _buildPlanTab(plans[index], index),
            ),
            spacing: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanTab(SubscriptionType plan, int index) {
    final isSelected = _selectedPlanIndex == index;
    final isBestValue = plan.duration.toLowerCase().contains("year");
    final isfirstuser = plan.price.toInt();

    return GestureDetector(
      onTap: () {
        if (plan.price > 0) {
          setState(() {
            _selectedPlanIndex = index;
          });
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            width: 100,
            duration: Duration(milliseconds: 200),
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF2563EB) : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plan.duration,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  plan.price > 0 ? '₹${plan.price.toInt()}' : 'Free',
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Best Value',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          if (isfirstuser == 0)
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'First User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlanDetails(SubscriptionType plan) {
    final bool showOriginalPrice =
        plan.price > 0 &&
        plan.discountedPrice != null &&
        plan.discountedPrice!.toInt() != plan.price.toInt();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2563EB).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                plan.price > 0
                    ? '₹${plan.discountedPrice?.toInt() ?? plan.price.toInt()}'
                    : 'Free',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              if (showOriginalPrice) ...[
                SizedBox(width: 10),
                SizedBox(height: 10),
                Text(
                  '₹${plan.price.toInt()}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
              SizedBox(width: 4),

              Text(
                '/${plan.duration}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${plan.name} Plan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(SubscriptionType plan) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you get:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          ...plan.features.map(
            (feature) => Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 14, color: Colors.green),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(SubscriptionType plan) {
    final isFree = plan.price == 0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: isFree ? null : () => widget.onSubscribe(plan),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFree ? Colors.grey : Color(0xFF2563EB),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          isFree ? 'Already Subscribed' : 'Subscribe Now',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

void showSubscriptionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // allows full height control
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.70, // fixed height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SubscriptionBottomSheet(
          onSubscribe: (plan) async {
            print('Selected plan: ${plan.name} - ${plan.duration}');
            final provider = Provider.of<SubscriptionModelAuthview>(
              context,
              listen: false,
            );
            final success = await provider.initializeBookingAndPay(
              context,
              plan,
            );
            if (success) {
              Navigator.pop(context);
            }
          },
          onClose: () => Navigator.pop(context),
        ),
      );
    },
  );
}
