add_definitions(-DTRANSLATION_DOMAIN="breeze_kwin_deco")
include_directories(${CMAKE_SOURCE_DIR}/libbreezecommon)
set(SRCS breezebutton.cpp breezedecoration.cpp breezesettingsprovider.cpp breezeexceptionlist.cpp)
kconfig_add_kcfg_files(SRCS breezesettings.kcfgc)
add_library(breezewindecoration MODULE ${SRCS})
set_target_properties(breezewindecoration PROPERTIES OUTPUT_NAME org.kde.breezewin)
target_link_libraries(breezewindecoration PRIVATE breezecommon6 Qt6::DBus KF6::CoreAddons KF6::ConfigGui
    KF6::GuiAddons KF6::I18n KF6::IconThemes KF6::ColorScheme KDecoration3::KDecoration)
install(TARGETS breezewindecoration DESTINATION ${KDE_INSTALL_PLUGINDIR}/${KDECORATION_PLUGIN_DIR})
