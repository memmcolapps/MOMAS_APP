# MomasPay+ Recommended File Structure

> Reference map for gradual migration. Touch a feature → migrate it.

```
lib/
  main.dart
  app/
    app.dart                          # MaterialApp + global providers
    app_entry.dart                    # onboarding vs auth decision
    app_config.dart

  core/
    network/
      request.dart
      routes.dart
    storage/
      shared_pref.dart
    utils/
      alert_dialog_view.dart
      amount_formatter.dart
      app_info.dart
      bio_metric.dart
      colors.dart
      constant.dart
      date_utils.dart
      images.dart
      keyboard_utils.dart
      launcher.dart
      month_helper.dart
      navigation.dart
      network_enum.dart
      payment.dart
      receipt_builder.dart
      screen_utils.dart
      service_launcher.dart
      strings.dart
      time_util.dart
      validators.dart
      vat_calculator.dart
    theme/
      theme.dart
      text_styles.dart
      text_utils.dart
    widgets/                          # shared reusable widgets
      mo_button.dart
      mo_form.dart
      mo_passcode.dart
      mo_selectable_text_form.dart
      mo_transaction_success_screen.dart
      network_selector.dart
      pop_button.dart
      rating_star.dart
      shadow_container.dart
      error_modal.dart
      bottom_sheet.dart
      search_bottom_sheet/
        bottom_sheet.dart
        bottom_sheet_route.dart
        bottom_sheet_suspended_curve.dart
        cupertino_bottom_sheet.dart
        drop_down_helper.dart
        error_switch.dart
        ka_dropdown.dart
        modal_scroll_controller.dart
        payment_bottom_sheet.dart
        scrolltotop_statusbar_handler.dart
        selection_list_bottom.dart
        velocity_tracker.dart
      update_modal/
        app_info.dart
        modal_content.dart
        modal_content_header.dart
        update_action_buttons.dart
        update_modal.dart
        whats_new.dart
    cubits/
      auth_cubit/
        auth_cubit.dart
        auth_state.dart
      tab_cubit/
        tab_cubit.dart
      app_version_cubit/
        update_cubit.dart
        update_state.dart

  features/
    onboarding/
      screens/
        intro_page.dart
        build_intro_slide.dart
        intro_dot.dart

    auth/
      data/
        models/
          login_request.dart
          register_request.dart
        repositories/
          auth_repository.dart
        services/
          auth_service.dart
      bloc/
        login/
          login_bloc.dart
          login_event.dart
          login_state.dart
        register/
          register_bloc.dart
          register_event.dart
          register_state.dart
      cubit/
        auth_view_cubit.dart          # login <-> forgot password switching
      screens/
        auth_screen.dart              # shared scaffold (header + body shell)
        login_body.dart
        forgot_password_body.dart
        email_screen.dart
        email_code_screen.dart
        auth_wrapper.dart
        registration/
          account_setup.dart
          registration_success_screen.dart
        reset_password/
          reset_password_screen.dart

    dashboard/
      data/
        models/
          feature.dart
          dashboard_model.dart
          wallet.dart
          promo.dart
          user_model.dart
        repositories/
          dashboard_repository.dart
        services/
          dashboard_service.dart
      bloc/
        dashboard_bloc.dart
        dashboard_event.dart
        dashboard_state.dart
      screens/
        root_screen.dart
        main_screen.dart
      widgets/
        home_page_header.dart
        main_balance.dart
        features_grid.dart
        quick_widgets.dart
        promo_section.dart
        disconnection_banner.dart
      utils/
        dashboard_builder.dart
        check_admin_charge_checker.dart

    analytics/
      data/
        models/
          analytics_data.dart
          analytics_data_response.dart
          chart_data.dart
          ring_data.dart
          transaction_data_response.dart
        repositories/
          analysis_data_repository.dart
      bloc/
        analysis/
          analysis_bloc.dart
          analysis_event.dart
          analysis_state.dart
        token_report/
          token_report_bloc.dart
          token_report_event.dart
          token_report_state.dart
        transaction_analysis/
          transaction_analysis_bloc.dart
          transaction_analysis_event.dart
          transaction_analysis_state.dart
        utility_metrics/
          utility_metrics_bloc.dart
          utility_metrics_event.dart
          utility_metrics_state.dart
      screens/
        analytics.dart
        analytics_view.dart
        metrics_screen.dart
      widgets/
        access_tokens.dart
        power_usage_section.dart
        transaction_history.dart
        transaction_record.dart
        reusable/
          filter_dropdown.dart
          filter_pills.dart
          section_header.dart
          trend_badge.dart
          shimmer/
            section_header_shimmer.dart
            shimmer_box.dart
            shimmer_line.dart
        shimmers/
          access_tokens_shimmer.dart
          analytics_shimmer.dart
          transaction_history_shimmer.dart
          transaction_record_shimmer.dart
          utility_metrics_shimmer.dart
        utility_metrics/
          stat_card.dart
          utility_metrics.dart
        charts/
          daily_usage_chart.dart
          weekly_usage_chart.dart
          concentric_ring_chart/
            concentric_ring_chart.dart
            legend_item.dart
            ring_painter.dart
          transaction_line_chart/
            empty_chart.dart
            transaction_line_chart.dart

    transactions/
      data/
        models/
          transaction_details.dart
          transaction_data_response.dart
          payment_response.dart
          payment_verification_response.dart
          page_data.dart
        repositories/
          payment_repository.dart
      bloc/
        payment/
          payment_bloc.dart
          payment_event.dart
          payment_state.dart
      screens/
        transactions.dart
      widgets/
        transaction_card.dart
        loading_dialog.dart
        skeleton_transaction_card.dart
        skeleton_transaction_list.dart

    bills/
      data/
        models/
          airtime_request.dart
          cable_tv_request.dart
          data_request.dart
          cable_tv_response.dart
          cable_tv_verification_response.dart
          data_response.dart
        repositories/
          bill_repository.dart
      bloc/
        airtime/
          airtime_bloc.dart
          airtime_event.dart
          airtime_state.dart
        cable_tv/
          cable_tv_bloc.dart
          cable_event.dart
          cable_tv_state.dart
        data/
          data_bloc.dart
          data_event.dart
          data_state.dart
      screens/
        bill_selected_screen.dart
        actions/
          airtime_screen.dart
          cable_tv_screen.dart
          data_screen/
            data_screen.dart
            dropdown_placeholder.dart
            plan_dropdown.dart
      widgets/
        contact_picker.dart
        form_card.dart
        label.dart

    meter_payment/
      data/
        models/
          momas_meter_buy.dart
          momas_payment_response.dart
          momas_meter_response.dart
          meter_payment_response.dart
          generate_token_request.dart
          generate_token_response.dart
          tariff.dart
          vending_properties.dart
        repositories/
          payment_repository.dart
      bloc/
        momas/
          momas_bloc.dart
          momas_event.dart
          momas_state.dart
      screens/
        momas_payment_screen.dart
        reprint_token_screen.dart
        access_token_screen.dart
        access_token_verification.dart
      widgets/
        token_tile_view.dart

    access_token/
      data/
        models/
          access_token_list_data.dart
        repositories/
          access_token_repository.dart
      bloc/
        access_token_bloc.dart
        access_token_event.dart
        access_token_state.dart

    arrears/
      data/
        models/
          arrears_items.dart
      bloc/
        arrears_bloc.dart
      screens/
        arrears_page.dart
      widgets/
        arrears_empty.dart
        arrears_shimmer.dart

    services/
      data/
        models/
          service_response.dart
          service_data_response.dart
          service_type_response.dart
          artisan_list_response.dart
        repositories/
          service_repository.dart
      bloc/
        service_bloc.dart
        service_event.dart
        service_state.dart
      screens/
        service_screen.dart
      widgets/
        service_preview.dart
        rating_widget.dart

    support/
      screens/
        support_screen.dart
      widgets/
        support_option_card.dart

    profile/
      data/
        models/
          bank_details.dart
          estate_response.dart
          set_estate_request.dart
          is_admin_fees_paid.dart
          generic_response.dart
          comment_response.dart
        repositories/
          setting_repository.dart
      bloc/
        setting/
          setting_bloc.dart
          setting_event.dart
          setting_state.dart
      screens/
        profile_screen.dart
        request_meter_screen.dart
      widgets/
        profile_info_card.dart

    app_update/
      data/
        models/
          app_version_response.dart
        repositories/
          app_update_repository.dart
      screens/
        app_update_wrapper.dart

  tabs/                               # navigation shell — not a feature
    root_screen.dart
    nav_config.dart
    nav_destination.dart
    nav_item.dart
    tabview_skeleton.dart
    shared/
      action_detail_skeleton.dart
      stack_screen_skeleton.dart
```

---

## Rules

- `core/` — no feature-specific code. Only things used by 2+ features
- `features/X/` — self-contained. A feature should be movable without touching others
- A feature can import from `core/` but **never** directly from another feature
- If two features share something, it moves to `core/`
- Global blocs (`AuthCubit`, `TabCubit`, `AppVersionCubit`) live in `core/cubits/`
- `tabs/` stays at root — it is the shell, not a feature

---

## Migration Order (touch a feature → migrate it)

| Priority | Feature | Notes |
|----------|---------|-------|
| 1 | `auth` | Currently in progress |
| 2 | `core/widgets` | Move reuseable/ → core/widgets/ |
| 3 | `core/utils` | Move utils/ → core/utils/ + core/theme/ |
| 4 | `dashboard` | Move screens + bloc |
| 5 | `analytics` | Large but self-contained |
| 6 | `bills` | Group airtime, cable, data blocs |
| 7 | `transactions` | |
| 8 | `meter_payment` | |
| 9 | `profile` | |
| 10 | `support`, `arrears`, `services` | Small, fast |

---

## Notes

- `user_model.dart` lives in `auth/data/models/` — profile references it from there
- `payment_repository` — decide if `transactions` and `meter_payment` share one or split
- `arrears_bloc` currently has no event/state files listed — check if it's a Cubit
