# frozen_string_literal: true

#
# Copyright (C) 2014 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

module Quizzes
  class QuizSerializer < Canvas::APISerializer
    include LockedSerializer
    include PermissionsSerializer

    root :quiz

    attributes :id,
               :title,
               :html_url,
               :mobile_url,
               :description,
               :quiz_type,
               :time_limit,
               :timer_autosubmit_disabled,
               :shuffle_answers,
               :show_correct_answers,
               :scoring_policy,
               :allowed_attempts,
               :one_question_at_a_time,
               :question_count,
               :points_possible,
               :cant_go_back,
               :access_code,
               :ip_filter,
               :due_at,
               :lock_at,
               :unlock_at,
               :published,
               :deleted,
               :unpublishable,
               :locked_for_user,
               :lock_info,
               :lock_explanation,
               :hide_results,
               :show_correct_answers_at,
               :hide_correct_answers_at,
               :all_dates,
               :can_unpublish,
               :can_update,
               :require_lockdown_browser,
               :require_lockdown_browser_for_results,
               :require_lockdown_browser_monitor,
               :lockdown_browser_monitor_data,
               :speed_grader_url,
               :permissions,
               :quiz_reports_url,
               :quiz_statistics_url,
               :message_students_url,
               :quiz_submission_html_url,
               :section_count,
               :moderate_url,
               :take_quiz_url,
               :quiz_extensions_url,
               :important_dates,
               # :takeable,
               :quiz_submissions_zip_url,
               :preview_url,
               :quiz_submission_versions_html_url,
               :assignment_id,
               :one_time_results,
               :only_visible_to_overrides,
               :visible_to_everyone,
               :assignment_group_id,
               :show_correct_answers_last_attempt,
               :version_number,
               :has_access_code,
               :post_to_sis,
               :anonymous_submissions,
               :migration_id,
               :in_paced_course

    def_delegators :@controller,
                   # :api_v1_course_assignment_group_url,
                   :speed_grader_course_gradebook_url,
                   :api_v1_course_quiz_submission_url,
                   :api_v1_course_quiz_submissions_url,
                   :api_v1_course_quiz_reports_url,
                   :api_v1_course_quiz_statistics_url,
                   :course_quiz_submission_html_url,
                   :api_v1_course_quiz_submission_users_url,
                   :api_v1_course_quiz_submission_users_message_url,
                   :api_v1_course_quiz_extensions_create_url,
                   :course_quiz_moderate_url,
                   :course_quiz_take_url,
                   :course_quiz_quiz_submissions_url,
                   :course_quiz_submission_versions_url

    delegate context: :quiz

    def_delegators :@quiz, :quiz_questions

    # has_one :assignment_group, embed: :ids, root: :assignment_group
    # has_one :quiz_submission, embed: :ids, root: :quiz_submissions, embed_in_root: true, serializer: Quizzes::QuizSubmissionSerializer
    # has_many :student_quiz_submissions, embed: :ids, root: :student_quiz_submissions
    # has_many :submitted_students, embed: :ids, root: :submitted_students
    # has_many :unsubmitted_students, embed: :ids, root: :unsubmitted_students

    # def serialize_ids(association)
    #   if (association.name == 'student_quiz_submissions')
    #     send(:student_quiz_submissions_url)
    #   else
    #     super association
    #   end
    # end

    # def quiz_submission
    #   @quiz_submission ||= if @self_quiz_submissions
    #     @self_quiz_submissions[quiz.id]
    #   else
    #     quiz.quiz_submissions.where(user_id: current_user).first
    #   end
    # end

    # def takeable
    #   return true if !quiz_submission
    #   return true if !quiz_submission.completed?
    #   return true if quiz.unlimited_attempts?
    #   (quiz_submission.completed? && quiz_submission.attempts_left > 0)
    # end

    def deleted
      quiz.deleted?
    end

    def take_quiz_url
      course_quiz_take_url(context, quiz, user_id: current_user.id)
    end

    # def initialize(object, options={})
    #   super
    #   @self_quiz_submissions = options[:quiz_submissions]
    # end

    # def submitted_students
    #   user_finder.submitted_students
    # end

    def preview_url
      course_quiz_take_url(context, quiz, preview: "1")
    end

    # def unsubmitted_students
    #   user_finder.unsubmitted_students
    # end

    # def student_quiz_submissions
    #   @student_quiz_submissions ||= quiz.quiz_submissions
    # end

    def message_students_url
      api_v1_course_quiz_submission_users_message_url(context, quiz)
    end

    def speed_grader_url
      return nil unless show_speedgrader?

      speed_grader_course_gradebook_url(context, assignment_id: quiz.assignment.id)
    end

    def moderate_url
      course_quiz_moderate_url(context, quiz)
    end

    def student_quiz_submissions_url
      if user_may_grade?
        api_v1_course_quiz_submissions_url(context, quiz)
      else
        nil
      end
    end

    def description
      return "" if hide_locked_description?

      if @serializer_options[:description_formatter]
        @serializer_options[:description_formatter].call(quiz.description)
      else
        quiz.description
      end
    end

    def unsubmitted_students_url
      api_v1_course_quiz_submission_users_url(context, quiz, submitted: "false")
    end

    def submitted_students_url
      api_v1_course_quiz_submission_users_url(context, quiz, submitted: true)
    end

    def quiz_submission_html_url
      course_quiz_submission_html_url(context, quiz)
    end

    def quiz_submission_versions_html_url
      course_quiz_submission_versions_url(context, quiz)
    end

    def html_url
      controller.send(:course_quiz_url, context, quiz)
    end

    def mobile_url
      controller.send(:course_quiz_url, context, quiz, persist_headless: 1, force_user: 1)
    end

    def all_dates
      Account.site_admin.feature_enabled?(:standardize_assignment_date_formatting) ? quiz.dates_hash_visible_to_v2(user, include_all_dates: true) : quiz.formatted_dates_hash(quiz.all_due_dates)
    end

    def section_count
      context.active_section_count
    end

    def locked_for_json_type
      "quiz"
    end

    # Teacher or Observer?
    def include_all_dates?
      !serializer_option(:skip_date_overrides) && due_dates == all_dates
    end

    def include_permissions?
      !serializer_option(:skip_permissions)
    end

    def filter(keys)
      super.select do |key|
        case key
        when :all_dates
          include_all_dates?
        when :unpublishable, :can_unpublish
          user_may_manage?
        when :section_count,
             :speed_grader_url,
             :message_students_url,
             :submitted_students,
             :only_visible_to_overrides
          user_may_grade?
        when :unsubmitted_students,
             :access_code
          user_may_grade? || user_may_manage?
        when :quiz_extensions_url, :moderate_url, :deleted
          accepts_jsonapi? && user_may_manage?
        when :quiz_submission_html_url, :take_quiz_url
          accepts_jsonapi?
        when :quiz_submissions_zip_url
          accepts_jsonapi? && user_may_grade? && has_file_uploads?
        when :preview_url
          accepts_jsonapi? && user_may_grade? && user_may_manage?
        when :locked_for_user, :lock_info, :lock_explanation
          !serializer_option(:skip_lock_tests)
        when :anonymous_submissions
          quiz.survey?
        when :permissions
          include_permissions?
        else true
        end
      end
    end

    def can_unpublish
      preloaded_permissions = serializer_option(:permissions)

      if preloaded_permissions.present?
        preloaded_permissions[quiz.id][:can_unpublish]
      else
        quiz.can_unpublish?
      end
    end
    alias_method :unpublishable, :can_unpublish

    def can_update
      quiz.grants_right?(current_user, :update)
    end

    def important_dates
      !!quiz.assignment&.important_dates
    end

    def question_count
      quiz.available_question_count
    end

    def require_lockdown_browser
      quiz.require_lockdown_browser?
    end

    def require_lockdown_browser_for_results
      quiz.require_lockdown_browser_for_results?
    end

    def require_lockdown_browser_monitor
      quiz.require_lockdown_browser_monitor?
    end

    delegate lockdown_browser_monitor_data: :quiz

    def serializable_object(...)
      hash = super
      # legacy v1 api
      if accepts_jsonapi?
        # since we're not embedding QuizStatistics as an association because
        # the statistics objects are built on-demand when the endpoint is
        # requested, and we only need the link, we'll have to assign it manually
        hash["links"] ||= {}
        hash["links"]["quiz_statistics"] = hash.delete(:quiz_statistics_url)
        hash["links"]["quiz_reports"] = hash.delete(:quiz_reports_url)
      else
        hash.delete("links")
        # id = hash['assignment_group']
        # hash['assignment_group_id'] = quiz.assignment_group.try(:id)
      end
      if (mc_status = serializer_option(:master_course_status))
        hash.merge!(quiz.master_course_api_restriction_data(mc_status))
      end
      hash
    end

    # def assignment_group_url
    #   api_v1_course_assignment_group_url(context, quiz.assignment_group.id)
    # end

    def quiz_reports_url
      api_v1_course_quiz_reports_url(quiz.context, quiz)
    end

    def quiz_statistics_url
      api_v1_course_quiz_statistics_url(quiz.context, quiz)
    end

    def quiz_extensions_url
      api_v1_course_quiz_extensions_create_url(quiz.context, quiz)
    end

    def only_visible_to_overrides
      quiz.only_visible_to_overrides || false
    end

    def visible_to_everyone
      quiz.visible_to_everyone || false
    end

    def stringify_ids?
      !!(accepts_jsonapi? || stringify_json_ids?)
    end

    def quiz_submissions_zip_url
      course_quiz_quiz_submissions_url(quiz.context, quiz.id, zip: 1)
    end

    private

    def show_speedgrader?
      quiz.assignment.present? && quiz.published? && quiz.assignment.can_view_speed_grader?(current_user)
    end

    def quiz_locked_for_user?
      quiz.locked_for? current_user
    end

    def user_is_student?
      context.user_is_student? current_user
    end

    def hide_locked_description?
      user_is_student? && quiz_locked_for_user?
    end

    def due_dates
      @due_dates ||= quiz.dates_hash_visible_to(current_user)
    end

    # If the current user is a student and is in a course section which has
    # an assignment override, the date will be that of the section's, otherwise
    # we will use the Quiz's.
    #
    # @param [:due_at|:lock_at|:unlock_at] domain
    def overridden_date(domain)
      if !serializer_option(:skip_date_overrides) &&
         context.user_has_been_student?(current_user) && due_dates.any?
        due_dates[0][domain]
      else
        quiz.send(domain)
      end
    end

    def due_at
      overridden_date :due_at
    end

    def lock_at
      overridden_date :lock_at
    end

    def unlock_at
      overridden_date :unlock_at
    end

    def user_may_grade?
      context.grants_right?(current_user, :manage_grades)
    end

    def user_may_manage?
      context.grants_any_right?(current_user, *RoleOverride::GRANULAR_MANAGE_ASSIGNMENT_PERMISSIONS)
    end

    def user_finder
      @user_finder ||= Quizzes::QuizUserFinder.new(quiz, current_user)
    end

    # def submission_for_current_user
    #   @submission_for_current_user ||= (
    #     quiz.quiz_submissions.where(user_id: current_user).first
    #   )
    # end

    # def submission_for_current_user?
    #   !!submission_for_current_user
    # end

    def has_file_uploads?
      quiz.has_file_upload_question?
    end

    def post_to_sis
      quiz.post_to_sis?
    end

    def timer_autosubmit_disabled
      quiz.timer_autosubmit_disabled?
    end

    def in_paced_course
      context.try(:enable_course_paces)
    end
  end
end
