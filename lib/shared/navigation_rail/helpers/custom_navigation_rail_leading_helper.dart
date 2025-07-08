part of '../custom_navigation_rail.dart';

Column _buildLeadingWidget(bool isExpanded, VoidCallback onToggleExpand) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.p20, top: AppSizes.p10),
        child: Container(
          width: isExpanded ? AppSizes.p160 : AppSizes.p80,
          height: isExpanded ? AppSizes.p112 : AppSizes.p80,
          decoration: BoxDecoration(
            border: Border.all(
              width: AppSizes.p2,
              color: AppColors.transparent,
            ),
            image: DecorationImage(
              image: AssetImage(AssetsEnum.menu.path),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: SvgLoader(
              SvgEnum.logo,
              width: isExpanded ? AppSizes.p56 : AppSizes.p40,
            ),
          ),
        ),
      ),
      IconButton(
        icon: _buildExpandCollapseIcon(isExpanded),
        color: AppColors.onPrimary,
        onPressed: onToggleExpand,
      ),
    ],
  );
}

Widget _buildExpandCollapseIcon(bool expanded) {
  return AnimatedRotation(
    turns: expanded ? 0.5 : 0.0,
    duration: const Duration(milliseconds: 300),
    child: const Icon(
      Icons.arrow_back_ios_new,
      size: AppSizes.p24,
      color: AppColors.onPrimary,
    ),
  );
}
