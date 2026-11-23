part of "../maps_main_page.dart";

class _MapsOnlyPreviewWidget extends StatelessWidget {
  const _MapsOnlyPreviewWidget({required this.addressEntity, required this.onAddressTapped});
  final MapAddressEntity addressEntity;
  final void Function() onAddressTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(title: Text(appLocalizer.maps, style: TextStyles.bold16), centerTitle: true),
        const Expanded(child: IgnorePointer(child: SizedBox.expand())),
        InkWell(
          onTap: onAddressTapped,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(appLocalizer.addressDetails, style: TextStyles.bold15.copyWith(color: AppColors.black800)),
                  const SizedBox(height: 12),
                  Material(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () =>
                          LaunchUrlUtils.openUrl(url: GoogleMapsConstants.getGoogleMapsLocationLink(addressEntity.lat, addressEntity.lng)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 22, color: AppColors.black800),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                addressEntity.address,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.semiBold14.copyWith(color: AppColors.black800),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
